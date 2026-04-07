import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:warungpakwardi/helper/app_event_bus.dart';
import 'package:warungpakwardi/helper/app_validator.dart'; // ← Tambahkan ini
import '../../../db/local/local_product_repository.dart';
import '../../../models/Product.dart';

import 'product_form_event.dart';
import 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  final LocalProductRepository localProductRepo = LocalProductRepository();
  final uuid = const Uuid();

  ProductFormBloc() : super(ProductFormState.initial()) {
    // Load product data for editing
    on<LoadProductForEditEvent>((event, emit) {
      emit(
        state.copyWith(
          id: event.product.id,
          name: event.product.name,
          price: event.product.price.toDouble(),
          purchasePrice: event.product.purchasePrice.toDouble(),
          amountPerUnit: event.product.amountPerUnit,
          stock: event.product.stock,
          unit: event.product.unit,
          isEdit: true,
          fieldErrors: {}, // Clear errors on load
        ),
      );
    });

    // Handle update of the product name (Real-time validation)
    on<UpdateProductName>((event, emit) {
      final nameError = AppValidator.validateProductName(event.name);
      final newErrors = Map<String, String?>.from(state.fieldErrors);
      newErrors['name'] = nameError;
      emit(state.copyWith(name: event.name, fieldErrors: newErrors));
    });

    // Handle update of the product price
    on<UpdateProductPrice>((event, emit) {
      final priceError = AppValidator.validatePrice(event.price);
      final newErrors = Map<String, String?>.from(state.fieldErrors);
      newErrors['price'] = priceError;
      emit(state.copyWith(price: event.price, fieldErrors: newErrors));
    });

    // Handle update of the product purchase price
    on<UpdateProductPurchasePrice>((event, emit) {
      final purchasePriceError = AppValidator.validatePurchasePrice(event.purchasePrice);
      final newErrors = Map<String, String?>.from(state.fieldErrors);
      newErrors['purchasePrice'] = purchasePriceError;
      emit(state.copyWith(purchasePrice: event.purchasePrice, fieldErrors: newErrors));
    });

    // Handle update of the amount per unit
    on<UpdateProductAmountPerUnit>((event, emit) {
      final amountError = AppValidator.validateAmountPerUnit(event.amountPerUnit);
      final newErrors = Map<String, String?>.from(state.fieldErrors);
      newErrors['amountPerUnit'] = amountError;
      emit(state.copyWith(amountPerUnit: event.amountPerUnit, fieldErrors: newErrors));
    });

    // Handle update of the unit
    on<UpdateProductUnit>((event, emit) {
      final unitError = AppValidator.validateUnit(event.unit);
      final newErrors = Map<String, String?>.from(state.fieldErrors);
      newErrors['unit'] = unitError;
      emit(state.copyWith(unit: event.unit, fieldErrors: newErrors));
    });

    // Handle update of the product stock
    on<UpdateProductStock>((event, emit) {
      final stockError = AppValidator.validateStock(event.stock);
      final newErrors = Map<String, String?>.from(state.fieldErrors);
      newErrors['stock'] = stockError;
      emit(state.copyWith(stock: event.stock, fieldErrors: newErrors));
    });

    on<SubmitProductForm>((event, emit) async {
      // 1. Validasi menyeluruh sebelum submit
      final errors = AppValidator.validateProductForm(
        name: state.name,
        price: state.price,
        purchasePrice: state.purchasePrice,
        amountPerUnit: state.amountPerUnit,
        unit: state.unit,
        stock: state.stock,
      );

      if (!AppValidator.isFormValid(errors)) {
        emit(state.copyWith(fieldErrors: errors, isLoading: false));
        return;
      }

      emit(state.copyWith(isLoading: true, errorMessage: null, fieldErrors: {}));

      // 2. Cek Nama Unik (Case-Insensitive)
      final isDuplicate = await localProductRepo.isProductNameDuplicate(
        state.name,
        excludeId: state.isEdit ? state.id : null,
      );

      if (isDuplicate) {
        final newErrors = Map<String, String?>.from(state.fieldErrors);
        newErrors['name'] = 'Produk dengan nama ini sudah ada';
        emit(state.copyWith(fieldErrors: newErrors, isLoading: false));
        return;
      }

      try {
        final now = DateTime.now();
        final productId = state.isEdit ? event.productId : uuid.v4();

        final product = Product(
          id: productId,
          name: state.name,
          price: state.price,
          purchasePrice: state.purchasePrice,
          amountPerUnit: state.amountPerUnit,
          unit: state.unit,
          stock: state.stock,
          createdAt: state.isEdit ? null : now,
          updatedAt: now,
          isSynced: 1,
        );

        // 1. Simpan ke SQLite lokal
        if (state.isEdit) {
          await localProductRepo.updateProduct(product);
          AppEventBus.instance.fire(AppEvent.productUpdated);
        } else {
          await localProductRepo.insertProduct(product);
          AppEventBus.instance.fire(AppEvent.productCreated);
        }

        emit(state.copyWith(isLoading: false, isSuccess: true, fieldErrors: {}));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}
