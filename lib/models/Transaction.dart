class Transaction {
  final String transactionId;
  final DateTime transactionDate;
  final int totalItems;
  final int totalPrice;

  Transaction({
    required this.transactionId,
    required this.transactionDate,
    required this.totalItems,
    required this.totalPrice,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'] ?? json['id'] ?? '',
      transactionDate:
          json['transaction_date'] != null
              ? DateTime.tryParse(json['transaction_date']) ?? DateTime(1970)
              : DateTime(1970),
      totalItems: json['total_items'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'transaction_date': transactionDate.toIso8601String(),
      'total_items': totalItems,
      'total_price': totalPrice,
    };
  }
}
