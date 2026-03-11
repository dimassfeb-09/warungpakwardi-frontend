import 'package:warungpakwardi/models/TransactionItem.dart';

class TransactionDetail {
  final String transactionId;
  final DateTime transactionDate;
  final List<TransactionItem> items;
  final int subtotal;
  final int total;

  TransactionDetail({
    required this.transactionId,
    required this.transactionDate,
    required this.items,
    required this.subtotal,
    required this.total,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      transactionId: json['transaction_id'] ?? '',
      transactionDate:
          json['transaction_date'] != null
              ? DateTime.parse(json['transaction_date'])
              : DateTime(1970),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => TransactionItem.fromJson(item))
              .toList() ??
          [],
      subtotal: json['subtotal'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'transaction_date': transactionDate.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'total': total,
    };
  }
}
