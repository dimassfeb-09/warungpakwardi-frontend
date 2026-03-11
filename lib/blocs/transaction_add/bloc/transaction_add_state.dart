import 'package:equatable/equatable.dart';
import 'package:warungpakwardi/models/Product.dart';

class CheckoutItem {
  final int quantity;
  final Product product;

  CheckoutItem({required this.quantity, required this.product});

  CheckoutItem copyWith({int? quantity, Product? product}) {
    return CheckoutItem(
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}

class TransactionAddState extends Equatable {
  final List<CheckoutItem> items;

  const TransactionAddState({this.items = const []});

  double get totalPrice => items.fold(
    0,
    (sum, item) => sum + ((item.product.price ?? 0) * item.quantity),
  );

  @override
  List<Object?> get props => [items];
}

class TransactionAddLoadingState extends TransactionAddState {}

class TransactionAddLoadedState extends TransactionAddState {
  final String transactionId;

  const TransactionAddLoadedState({super.items, required this.transactionId});
}

class TransactionAddErrorState extends TransactionAddState {
  final String message;

  const TransactionAddErrorState({super.items, required this.message});
}
