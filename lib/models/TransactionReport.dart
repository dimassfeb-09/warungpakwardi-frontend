class TransactionReport {
  final List<TransactionSummaryPerDay> transactionSummaryMonthly;
  final List<TransactionSummaryPerDay> transactionSummaryThisWeek;
  final TransactionSummaryPerDay transactionSummaryToday;
  final List<ProductSalesSummary> totalSoldProduct;
  final List<TopSellingProduct> productTopSelling;
  final int totalRevenue;
  final int totalProfit; // Added
  final int transactionCount;
  final int itemsSoldTotal;

  TransactionReport({
    required this.transactionSummaryMonthly,
    required this.transactionSummaryThisWeek,
    required this.transactionSummaryToday,
    required this.totalSoldProduct,
    required this.productTopSelling,
    this.totalRevenue = 0,
    this.totalProfit = 0, // Added
    this.transactionCount = 0,
    this.itemsSoldTotal = 0,
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
      totalRevenue: json['total_revenue'] ?? 0,
      totalProfit: json['total_profit'] ?? 0,
      transactionCount: json['transaction_count'] ?? 0,
      itemsSoldTotal: json['items_sold_total'] ?? 0,
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
      'total_revenue': totalRevenue,
      'total_profit': totalProfit, // Added
      'transaction_count': transactionCount,
      'items_sold_total': itemsSoldTotal,
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
  final int totalProfit; // Added

  ProductSalesSummary({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.totalRevenue,
    required this.totalProfit, // Added
  });

  factory ProductSalesSummary.fromJson(Map<String, dynamic> json) {
    return ProductSalesSummary(
      productId: json['product_id'],
      name: json['name'],
      quantity: json['quantity'],
      totalRevenue: json['total_revenue'],
      totalProfit: json['total_profit'] ?? 0, // Added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'quantity': quantity,
      'total_revenue': totalRevenue,
      'total_profit': totalProfit, // Added
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
