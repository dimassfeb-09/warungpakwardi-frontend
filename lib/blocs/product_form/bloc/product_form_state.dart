import 'package:equatable/equatable.dart';

class ProductFormState extends Equatable {
  final String id;
  final String name;
  final double price;
  final int amountPerUnit;
  final String unit;
  final int stock;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final bool isEdit;

  const ProductFormState({
    required this.id,
    required this.name,
    required this.price,
    required this.amountPerUnit,
    required this.unit,
    required this.stock,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.isEdit = false,
  });

  factory ProductFormState.initial() => const ProductFormState(
    id: '',
    name: '',
    price: 0.0,
    amountPerUnit: 0,
    unit: '',
    stock: 0,
    isLoading: false,
    isSuccess: false,
    errorMessage: null,
    isEdit: false,
  );

  ProductFormState copyWith({
    String? id,
    String? name,
    double? price,
    int? amountPerUnit,
    String? unit,
    int? stock,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool? isEdit,
  }) {
    return ProductFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      amountPerUnit: amountPerUnit ?? this.amountPerUnit,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      isEdit: isEdit ?? this.isEdit,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    amountPerUnit,
    unit,
    stock,
    isLoading,
    isSuccess,
    errorMessage,
    isEdit,
  ];
}
