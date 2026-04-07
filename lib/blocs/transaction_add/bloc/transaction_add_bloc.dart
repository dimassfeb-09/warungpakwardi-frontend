import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:warungpakwardi/db/local/local_product_repository.dart';
import 'package:warungpakwardi/db/local/local_transaction_repository.dart';
import 'package:warungpakwardi/helper/app_event_bus.dart';
import 'package:warungpakwardi/helper/app_validator.dart'; // ← Tambahkan ini
import 'package:warungpakwardi/models/Transaction.dart' as model;
import 'package:warungpakwardi/models/TransactionItem.dart';

import 'transaction_add_event.dart';
import 'transaction_add_state.dart';

class TransactionAddBloc
    extends Bloc<TransactionAddEvent, TransactionAddState> {
  final LocalTransactionRepository localTransactionRepo = LocalTransactionRepository();
  final LocalProductRepository localProductRepo = LocalProductRepository(); // ← Tambahkan ini
  final uuid = const Uuid();

  TransactionAddBloc() : super(const TransactionAddState()) {
    on<AddProductToCart>(_onAddProduct);
    on<RemoveProductFromCart>(_onRemoveProduct);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<TransactionClearField>(_onClearField);
    on<SubmitTransactionEvent>(_onSubmit);
  }

  void _onAddProduct(
    AddProductToCart event,
    Emitter<TransactionAddState> emit,
  ) {
    final items = List<CheckoutItem>.from(state.items);
    final index = items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (index != -1) {
      if (items[index].quantity < items[index].product.stock) {
        final updated = items[index].copyWith(
          quantity: items[index].quantity + 1,
        );
        items[index] = updated;
      }
    } else {
      if (event.product.stock > 0) {
        items.add(CheckoutItem(product: event.product, quantity: 1));
      }
    }

    emit(TransactionAddState(items: items));
  }

  void _onRemoveProduct(
    RemoveProductFromCart event,
    Emitter<TransactionAddState> emit,
  ) {
    final items =
        state.items
            .where((item) => item.product.id != event.product.id)
            .toList();
    emit(TransactionAddState(items: items));
  }

  void _onIncreaseQuantity(
    IncreaseQuantity event,
    Emitter<TransactionAddState> emit,
  ) {
    final items =
        state.items.map((item) {
          if (item.product.id == event.product.id &&
              item.quantity < item.product.stock) {
            return item.copyWith(quantity: item.quantity + 1);
          }
          return item;
        }).toList();

    emit(TransactionAddState(items: items));
  }

  void _onDecreaseQuantity(
    DecreaseQuantity event,
    Emitter<TransactionAddState> emit,
  ) {
    final items =
        state.items.map((item) {
          if (item.product.id == event.product.id && item.quantity > 1) {
            return item.copyWith(quantity: item.quantity - 1);
          }
          return item;
        }).toList();

    emit(TransactionAddState(items: items));
  }

  void _onClearField(
    TransactionClearField event,
    Emitter<TransactionAddState> emit,
  ) {
    emit(const TransactionAddState());
  }

  void _onSubmit(
    SubmitTransactionEvent event,
    Emitter<TransactionAddState> emit,
  ) async {
    // ━━━ 1. VALIDASI ━━━
    
    // a. Cart tidak boleh kosong
    final cartError = AppValidator.validateCartNotEmpty(event.checkoutItem.length);
    if (cartError != null) {
      emit(TransactionAddErrorState(items: state.items, message: cartError));
      return;
    }

    // b. Cek Stok untuk semua item
    for (final item in event.checkoutItem) {
      final stockError = AppValidator.validateQuantityVsStock(
        item.quantity,
        item.product.stock,
      );
      if (stockError != null) {
        emit(
          TransactionAddErrorState(
            items: state.items,
            message: "${item.product.name}: $stockError",
          ),
        );
        return;
      }
    }

    try {
      emit(TransactionAddLoadingState(items: state.items));

      final transactionId = uuid.v4();
      final now = DateTime.now();
      
      num totalItems = 0;
      int totalPrice = 0;
      List<TransactionItem> dbItems = [];

      for (var c in event.checkoutItem) {
        totalItems += c.quantity;
        totalPrice += (c.product.price * c.quantity).toInt();
        dbItems.add(TransactionItem(
          productId: c.product.id,
          name: c.product.name,
          quantity: c.quantity,
          unitPrice: c.product.price.toInt(),
          totalPrice: (c.product.price * c.quantity).toInt(),
          purchasePrice: c.product.purchasePrice.toDouble(),
          transactionId: transactionId,
        ));
      }

      final transaction = model.Transaction(
        transactionId: transactionId,
        transactionDate: now,
        totalItems: totalItems,
        totalPrice: totalPrice,
        isSynced: 1, // Full local version
      );

      // 2. Simpan Transaksi ke database
      await localTransactionRepo.insertTransaction(transaction, dbItems);

      // 3. KURANGI STOK PRODUK (Deduction)
      for (final item in event.checkoutItem) {
        final newStock = item.product.stock - item.quantity;
        await localProductRepo.updateProductStockManual(item.product.id, newStock);
      }

      // 4. Fire refresh event ke dashboard & produk
      AppEventBus.instance.fire(AppEvent.transactionCreated);

      // Delay sedikit untuk UX
      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        TransactionAddLoadedState(transactionId: transactionId),
      );
    } catch (e) {
      emit(
        TransactionAddErrorState(
          items: state.items,
          message: "Terjadi kesalahan: ${e.toString()}",
        ),
      );
    }
  }
}
