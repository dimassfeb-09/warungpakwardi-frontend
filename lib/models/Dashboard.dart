import 'package:warungpakwardi/models/Product.dart';

class Dashboard {
  final List<Product>? productLowStock;
  final int revenue;
  final int totalTransaction;
  final int totalProduct;

  Dashboard({
    this.productLowStock,
    required this.revenue,
    required this.totalTransaction,
    required this.totalProduct,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      productLowStock:
          json['product_low_stock'] != null
              ? (json['product_low_stock'] as List)
                  .map((e) => Product.fromJson(e))
                  .toList()
              : null,
      revenue:
          json['revenue'] != null
              ? json['revenue'] as int
              : 0, // Menangani null
      totalTransaction:
          json['total_transaction'] != null
              ? json['total_transaction'] as int
              : 0, // Menangani null
      totalProduct:
          json['total_product'] != null
              ? json['total_product'] as int
              : 0, // Menangani null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_low_stock': productLowStock?.map((e) => e.toJson()).toList(),
      'revenue': revenue,
      'total_transaction': totalTransaction,
      'total_product': totalProduct,
    };
  }
}
