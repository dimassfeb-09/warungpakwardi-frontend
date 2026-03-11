class TransactionReport {
  final List<TransactionSummaryPerDay> transactionSummaryMonthly;
  final List<TransactionSummaryPerDay> transactionSummaryThisWeek;
  final TransactionSummaryPerDay transactionSummaryToday;
  final List<ProductSalesSummary> totalSoldProduct;
  final List<TopSellingProduct> productTopSelling;

  TransactionReport({
    required this.transactionSummaryMonthly,
    required this.transactionSummaryThisWeek,
    required this.transactionSummaryToday,
    required this.totalSoldProduct,
    required this.productTopSelling,
  });

  factory TransactionReport.fromJson(Map<String, dynamic> json) {
    return TransactionReport(
      transactionSummaryMonthly:
          (json['transaction_summary_monthly'] as List)
              .map((e) => TransactionSummaryPerDay.fromJson(e))
              .toList(),
      transactionSummaryThisWeek:
          (json['transaction_summary_this_week'] as List)
              .map((e) => TransactionSummaryPerDay.fromJson(e))
              .toList(),
      transactionSummaryToday: TransactionSummaryPerDay.fromJson(
        json['transaction_summary_today'],
      ),
      totalSoldProduct:
          (json['total_sold_product'] as List)
              .map((e) => ProductSalesSummary.fromJson(e))
              .toList(),
      productTopSelling:
          (json['product_top_selling'] as List)
              .map((e) => TopSellingProduct.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_summary_monthly':
          transactionSummaryMonthly.map((e) => e.toJson()).toList(),
      'transaction_summary_this_week':
          transactionSummaryThisWeek.map((e) => e.toJson()).toList(),
      'transaction_summary_today': transactionSummaryToday.toJson(),
      'total_sold_product': totalSoldProduct.map((e) => e.toJson()).toList(),
      'product_top_selling': productTopSelling.map((e) => e.toJson()).toList(),
    };
  }
}

class TransactionSummaryPerDay {
  final String dayName;
  final String date;
  final int totalPerDay;

  TransactionSummaryPerDay({
    required this.dayName,
    required this.date,
    required this.totalPerDay,
  });

  factory TransactionSummaryPerDay.fromJson(Map<String, dynamic> json) {
    return TransactionSummaryPerDay(
      dayName: json['day_name'],
      date: json['date'],
      totalPerDay: json['total_per_day'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'day_name': dayName, 'date': date, 'total_per_day': totalPerDay};
  }
}

class ProductSalesSummary {
  final String productId;
  final String name;
  final int quantity;
  final int totalRevenue;

  ProductSalesSummary({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.totalRevenue,
  });

  factory ProductSalesSummary.fromJson(Map<String, dynamic> json) {
    return ProductSalesSummary(
      productId: json['product_id'],
      name: json['name'],
      quantity: json['quantity'],
      totalRevenue: json['total_revenue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'quantity': quantity,
      'total_revenue': totalRevenue,
    };
  }
}

class TopSellingProduct {
  final String productId;
  final String name;
  final int totalSold;
  final int revenue;

  TopSellingProduct({
    required this.productId,
    required this.name,
    required this.totalSold,
    required this.revenue,
  });

  factory TopSellingProduct.fromJson(Map<String, dynamic> json) {
    return TopSellingProduct(
      productId: json['product_id'],
      name: json['name'],
      totalSold: json['total_sold'],
      revenue: json['revenue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'total_sold': totalSold,
      'revenue': revenue,
    };
  }
}
