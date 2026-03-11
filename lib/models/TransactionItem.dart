class TransactionItem {
  final String name;
  final int quantity;
  final int unitPrice;
  final int totalPrice;

  TransactionItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unit_price'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }
}
