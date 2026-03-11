import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../db/remote/product_repository.dart';
import '../../../models/Product.dart';
import '../../../utils/secureStorage.dart';
import 'product_form_event.dart';
import 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductRepository productRepository = ProductRepository();

  ProductFormBloc() : super(ProductFormState.initial()) {
    // Load product data for editing
    on<LoadProductForEditEvent>((event, emit) {
      emit(
        state.copyWith(
          id: event.product.id,
          name: event.product.name,
          price: event.product.price.toDouble(),
          amountPerUnit: event.product.amountPerUnit,
          stock: event.product.stock,
          unit: event.product.unit,
          isEdit: true,
        ),
      );
    });

    // Handle update of the product name
    on<UpdateProductName>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    // Handle update of the product price
    on<UpdateProductPrice>((event, emit) {
      emit(state.copyWith(price: event.price));
    });

    // Handle update of the amount per unit
    on<UpdateProductAmountPerUnit>((event, emit) {
      emit(state.copyWith(amountPerUnit: event.amountPerUnit));
    });

    // Handle update of the unit (e.g., "pcs", "kg")
    on<UpdateProductUnit>((event, emit) {
      emit(state.copyWith(unit: event.unit));
    });

    // Handle update of the product stock
    on<UpdateProductStock>((event, emit) {
      emit(state.copyWith(stock: event.stock));
    });

    on<SubmitProductForm>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      try {
        final token = await secureStorage.read(key: "token");
        final product = Product(
          id: state.isEdit ? event.productId : '',
          name: state.name,
          price: state.price,
          amountPerUnit: state.amountPerUnit,
          unit: state.unit,
          stock: state.stock,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (state.isEdit) {
          await productRepository.updateProduct(token!, product);
        } else {
          await productRepository.createProduct(token!, product);
        }

        emit(state.copyWith(isLoading: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}
