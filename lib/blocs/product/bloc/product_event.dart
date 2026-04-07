part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class FetchProductEvent extends ProductEvent {}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  DeleteProductEvent({required this.productId});
}

class SearchProductEvent extends ProductEvent {
  final String query;

  SearchProductEvent(this.query);
}
