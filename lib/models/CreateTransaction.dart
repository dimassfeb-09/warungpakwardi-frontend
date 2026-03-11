class CreateTransaction {
  final String productId;
  final int quantity;

  CreateTransaction({required this.productId, required this.quantity});

  factory CreateTransaction.fromJson(Map<String, dynamic> json) {
    return CreateTransaction(
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'quantity': quantity};
  }
}
