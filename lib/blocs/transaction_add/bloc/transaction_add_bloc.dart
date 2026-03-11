import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/models/ResponseErrorAPI.dart';
import '../../../db/remote/transaction_repository.dart';
import '../../../models/CreateTransaction.dart';
import '../../../utils/secureStorage.dart';
import 'transaction_add_event.dart';
import 'transaction_add_state.dart';

class TransactionAddBloc
    extends Bloc<TransactionAddEvent, TransactionAddState> {
  TransactionRepository transactionRepository = TransactionRepository();

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
      final updated = items[index].copyWith(
        quantity: items[index].quantity + 1,
      );
      items[index] = updated;
    } else {
      items.add(CheckoutItem(product: event.product, quantity: 1));
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
          if (item.product.id == event.product.id) {
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
    emit(TransactionAddState());
  }

  void _onSubmit(
    SubmitTransactionEvent event,
    Emitter<TransactionAddState> emit,
  ) async {
    try {
      final token = await secureStorage.read(key: "token");
      emit(TransactionAddLoadingState());

      final response = await transactionRepository.createTransaction(
        token!,
        event.checkoutItem
            .map(
              (c) => CreateTransaction(
                productId: c.product.id,
                quantity: c.quantity,
              ),
            )
            .toList(),
      );

      // Delay 1 detik sebelum emit Loaded
      await Future.delayed(const Duration(seconds: 1));

      emit(
        TransactionAddLoadedState(transactionId: response.data!.transactionId),
      );
    } catch (e) {
      if (e is ResponseErrorAPI) {
        emit(TransactionAddErrorState(message: e.message));
      } else {
        emit(
          TransactionAddErrorState(
            message:
                "Terjadi kesalahan ketika membuat transaksi: ${e.toString()}",
          ),
        );
      }
    }
  }
}
