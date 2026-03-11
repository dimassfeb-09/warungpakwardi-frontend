import 'package:equatable/equatable.dart';
import 'package:warungpakwardi/blocs/transaction_add/bloc/transaction_add_state.dart';
import 'package:warungpakwardi/models/Product.dart';

abstract class TransactionAddEvent extends Equatable {
  const TransactionAddEvent();

  @override
  List<Object?> get props => [];
}

class TransactionClearField extends TransactionAddEvent {}

class AddProductToCart extends TransactionAddEvent {
  final Product product;

  const AddProductToCart(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveProductFromCart extends TransactionAddEvent {
  final Product product;

  const RemoveProductFromCart(this.product);

  @override
  List<Object?> get props => [product];
}

class IncreaseQuantity extends TransactionAddEvent {
  final Product product;

  const IncreaseQuantity(this.product);

  @override
  List<Object?> get props => [product];
}

class DecreaseQuantity extends TransactionAddEvent {
  final Product product;

  const DecreaseQuantity(this.product);

  @override
  List<Object?> get props => [product];
}

class SubmitTransactionEvent extends TransactionAddEvent {
  final List<CheckoutItem> checkoutItem;

  const SubmitTransactionEvent({required this.checkoutItem});
}
