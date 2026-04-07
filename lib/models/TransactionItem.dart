class TransactionItem {
  final String name;
  final num quantity;
  final int unitPrice;
  final int totalPrice;
  final double purchasePrice; // Added for profit calculation
  final String productId;
  final String? transactionId;

  TransactionItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.purchasePrice,
    required this.productId,
    this.transactionId,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unit_price'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
      purchasePrice: (json['purchase_price'] as num?)?.toDouble() ?? 0.0,
      productId: json['product_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'purchase_price': purchasePrice,
      'product_id': productId,
    };
  }

  Map<String, dynamic> toMap(String tId) {
    return {
      'transaction_id': transactionId ?? tId,
      'product_id': productId,
      'name': name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'purchase_price': purchasePrice,
    };
  }

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      name: map['name'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      totalPrice: map['total_price'],
      purchasePrice: (map['purchase_price'] as num?)?.toDouble() ?? 0.0,
      productId: map['product_id'],
      transactionId: map['transaction_id'],
    );
  }
}
