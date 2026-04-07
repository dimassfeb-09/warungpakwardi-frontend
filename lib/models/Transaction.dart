class Transaction {
  final String transactionId;
  final DateTime transactionDate;
  final num totalItems;
  final int totalPrice;

  final int isSynced;

  Transaction({
    required this.transactionId,
    required this.transactionDate,
    required this.totalItems,
    required this.totalPrice,
    this.isSynced = 1,
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
      isSynced: 1,
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

  Map<String, dynamic> toMap() {
    return {
      'id': transactionId,
      'transaction_date': transactionDate.toIso8601String(),
      'total_items': totalItems,
      'total_price': totalPrice,
      'is_synced': isSynced,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionId: map['id'],
      transactionDate: DateTime.parse(map['transaction_date']),
      totalItems: map['total_items'],
      totalPrice: map['total_price'],
      isSynced: map['is_synced'] ?? 1,
    );
  }
}
