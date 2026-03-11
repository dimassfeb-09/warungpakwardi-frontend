import 'package:equatable/equatable.dart';

import '../../../models/Product.dart';

abstract class ProductFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProductForEditEvent extends ProductFormEvent {
  final Product product;

  LoadProductForEditEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProductName extends ProductFormEvent {
  final String name;

  UpdateProductName(this.name);

  @override
  List<Object?> get props => [name];
}

class UpdateProductPrice extends ProductFormEvent {
  final double price;

  UpdateProductPrice(this.price);

  @override
  List<Object?> get props => [price];
}

class UpdateProductAmountPerUnit extends ProductFormEvent {
  final int amountPerUnit;

  UpdateProductAmountPerUnit(this.amountPerUnit);

  @override
  List<Object?> get props => [amountPerUnit];
}

class UpdateProductUnit extends ProductFormEvent {
  final String unit;

  UpdateProductUnit(this.unit);

  @override
  List<Object?> get props => [unit];
}

class UpdateProductStock extends ProductFormEvent {
  final int stock;

  UpdateProductStock(this.stock);

  @override
  List<Object?> get props => [stock];
}

class SubmitProductForm extends ProductFormEvent {
  final String productId;

  SubmitProductForm({required this.productId});

  @override
  List<Object?> get props => [productId];
}
