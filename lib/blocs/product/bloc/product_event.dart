part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class FetchProductEvent extends ProductEvent {}

class UpdateProductEvent extends ProductEvent {
  final Product updatedProduct;

  UpdateProductEvent(this.updatedProduct);
}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  DeleteProductEvent({required this.productId});
}
