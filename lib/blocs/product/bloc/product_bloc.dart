import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:warungpakwardi/models/Product.dart';
import 'package:warungpakwardi/models/ResponseErrorAPI.dart';
import 'package:warungpakwardi/utils/secureStorage.dart';

import '../../../db/remote/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository productRepository = ProductRepository();
  ProductBloc() : super(ProductInitial()) {
    on<FetchProductEvent>(_fetchProduct);
    on<UpdateProductEvent>(_updateProduct);
    on<DeleteProductEvent>(_deleteProduct);
  }

  void _fetchProduct(FetchProductEvent event, Emitter emit) async {
    emit(FetchProductLoadingState()); // Emit loading state immediately

    try {
      final token = await secureStorage.read(key: "token");
      final products = await productRepository.fetchProduct(token!);
      emit(FetchProductLoadedState(products: products.data ?? []));
    } catch (e) {
      if (e is ResponseErrorAPI) {
        emit(FetchProductErrorState(message: e.message));
      } else {
        emit(
          FetchProductErrorState(message: "An error occurred: ${e.toString()}"),
        );
      }
    }
  }

  void _deleteProduct(DeleteProductEvent event, Emitter emit) async {
    try {
      final currentState = state;
      emit(FetchProductLoadingState());
      final token = await secureStorage.read(key: "token");
      await productRepository.deleteProduct(token!, event.productId);
      final updatedProducts =
          currentState.products
              .where((product) => product.id != event.productId)
              .toList();
      emit(FetchProductLoadedState(products: updatedProducts));
    } catch (e) {
      if (e is ResponseErrorAPI) {
        emit(FetchProductErrorState(message: e.message));
      } else {
        emit(FetchProductErrorState(message: e.toString()));
      }
    }
  }

  void _updateProduct(UpdateProductEvent event, Emitter emit) async {
    final updatedProduct = event.updatedProduct;
    final currentState = state;

    emit(FetchProductLoadingState());

    try {
      final existingProducts = currentState.products;

      final index = existingProducts.indexWhere(
        (p) => p.id == updatedProduct.id,
      );

      List<Product> updatedProducts;

      if (index != -1) {
        // Jika produk sudah ada, update dengan copyWith
        final updated = existingProducts[index].copyWith(
          name: updatedProduct.name,
          price: updatedProduct.price,
          amountPerUnit: updatedProduct.amountPerUnit,
          unit: updatedProduct.unit,
          stock: updatedProduct.stock,
          updatedAt: updatedProduct.updatedAt,
          // tambahkan field lain jika ada
        );

        updatedProducts = List.from(existingProducts)..[index] = updated;
      } else {
        // Jika belum ada, tambahkan ke list
        updatedProducts = List.from(existingProducts)..add(updatedProduct);
      }

      emit(FetchProductLoadedState(products: updatedProducts));
    } catch (e) {
      if (e is ResponseErrorAPI) {
        emit(FetchProductErrorState(message: e.message));
      } else {
        emit(FetchProductErrorState(message: e.toString()));
      }
    }
  }
}
