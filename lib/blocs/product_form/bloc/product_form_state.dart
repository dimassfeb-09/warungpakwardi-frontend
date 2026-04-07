import 'package:equatable/equatable.dart';

class ProductFormState extends Equatable {
  final String id;
  final String name;
  final double price;
  final double purchasePrice;
  final int amountPerUnit;
  final String unit;
  final num stock;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final bool isEdit;
  
  /// Map error per-field untuk validasi real-time
  final Map<String, String?> fieldErrors;

  const ProductFormState({
    required this.id,
    required this.name,
    required this.price,
    this.purchasePrice = 0.0,
    required this.amountPerUnit,
    required this.unit,
    required this.stock,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.isEdit = false,
    this.fieldErrors = const {},
  });

  factory ProductFormState.initial() => const ProductFormState(
    id: '',
    name: '',
    price: 0.0,
    purchasePrice: 0.0,
    amountPerUnit: 0,
    unit: '',
    stock: 0,
    isLoading: false,
    isSuccess: false,
    errorMessage: null,
    isEdit: false,
    fieldErrors: {},
  );

  ProductFormState copyWith({
    String? id,
    String? name,
    double? price,
    double? purchasePrice,
    int? amountPerUnit,
    String? unit,
    num? stock,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool? isEdit,
    Map<String, String?>? fieldErrors,
  }) {
    return ProductFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      amountPerUnit: amountPerUnit ?? this.amountPerUnit,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      isEdit: isEdit ?? this.isEdit,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    purchasePrice,
    amountPerUnit,
    unit,
    stock,
    isLoading,
    isSuccess,
    errorMessage,
    isEdit,
    fieldErrors,
  ];
}
