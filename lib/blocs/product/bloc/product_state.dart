part of 'product_bloc.dart';

@immutable
sealed class ProductState {
  final List<Product> products;

  ProductState({required this.products});
}

final class ProductInitial extends ProductState {
  ProductInitial() : super(products: []);
}

class FetchProductLoadingState extends ProductState {
  FetchProductLoadingState() : super(products: []);
}

class FetchProductLoadedState extends ProductState {
  FetchProductLoadedState({required List<Product> products})
    : super(products: products);
}

class FetchProductErrorState extends ProductState {
  final String message;

  FetchProductErrorState({required this.message}) : super(products: []);
}

class UpdateProductSuccessState extends ProductState {
  UpdateProductSuccessState({required List<Product> products})
    : super(products: products);
}
