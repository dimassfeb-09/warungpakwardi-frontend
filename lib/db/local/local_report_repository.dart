import 'package:intl/intl.dart';
import 'package:warungpakwardi/db/local/database_helper.dart';
import 'package:warungpakwardi/models/TransactionReport.dart';

class LocalReportRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<TransactionReport> fetchReportData({DateTime? startDate, DateTime? endDate}) async {
    final db = await _dbHelper.database;

    // Use current month as default if no range provided
    final DateTime start = startDate ?? DateTime(DateTime.now().year, DateTime.now().month, 1);
    final DateTime end = endDate ?? DateTime.now();

    final startStr = DateFormat('yyyy-MM-dd').format(start);
    final endStr = DateFormat('yyyy-MM-dd').format(end);

    // 1. Transaction Summary Total for the range
    final totalResult = await db.rawQuery(
      '''
      SELECT SUM(t.total_price) as total_rev, 
             SUM((ti.unit_price - ti.purchase_price) * ti.quantity) as total_prof,
             COUNT(DISTINCT t.id) as count
      FROM transactions t
      JOIN transaction_items ti ON t.id = ti.transaction_id
      WHERE date(t.transaction_date) BETWEEN ? AND ?
    ''',
      [startStr, endStr],
    );
    
    final totalRevenue = (totalResult.first['total_rev'] as num?)?.toInt() ?? 0;
    final totalProfit = (totalResult.first['total_prof'] as num?)?.toInt() ?? 0;
    final transactionCount = (totalResult.first['count'] as num?)?.toInt() ?? 0;

    // 2. Daily Summary for the range (Charts)
    final dailyResult = await db.rawQuery(
      '''
      SELECT date(transaction_date) as date, 
             SUM(total_price) as total
      FROM transactions
      WHERE date(transaction_date) BETWEEN ? AND ?
      GROUP BY date(transaction_date)
      ORDER BY date(transaction_date) ASC
    ''',
      [startStr, endStr],
    );

    final summaryDaily = dailyResult.map((m) {
      final date = m['date'] as String;
      final dt = DateTime.parse(date);
      return TransactionSummaryPerDay(
        dayName: DateFormat('EEE').format(dt),
        date: date,
        totalPerDay: (m['total'] as num).toInt(),
      );
    }).toList();

    // 3. Product Sales Summary for the range
    final salesResult = await db.rawQuery('''
      SELECT ti.product_id, ti.name, 
             SUM(ti.quantity) as quantity, 
             SUM(ti.total_price) as total_revenue,
             SUM((ti.unit_price - ti.purchase_price) * ti.quantity) as total_profit
      FROM transaction_items ti
      JOIN transactions t ON ti.transaction_id = t.id
      WHERE date(t.transaction_date) BETWEEN ? AND ?
      GROUP BY ti.product_id, ti.name
      ORDER BY quantity DESC
    ''', [startStr, endStr]);

    final totalSoldProduct = salesResult.map((m) => ProductSalesSummary(
      productId: m['product_id'] as String,
      name: m['name'] as String,
      quantity: (m['quantity'] as num).toInt(),
      totalRevenue: (m['total_revenue'] as num).toInt(),
      totalProfit: (m['total_profit'] as num).toInt(),
    )).toList();

    // 4. Items Sold Total
    int itemsSoldTotal = 0;
    for (var item in totalSoldProduct) {
      itemsSoldTotal += item.quantity;
    }

    // 5. Top Selling Products (Limit 5)
    final topSelling = totalSoldProduct.take(5).map((s) => TopSellingProduct(
      productId: s.productId,
      name: s.name,
      totalSold: s.quantity,
      revenue: s.totalRevenue,
    )).toList();

    return TransactionReport(
      transactionSummaryMonthly: summaryDaily, 
      transactionSummaryThisWeek: summaryDaily.length > 7 ? summaryDaily.sublist(summaryDaily.length - 7) : summaryDaily,
      transactionSummaryToday: TransactionSummaryPerDay(
        dayName: DateFormat('EEEE').format(DateTime.now()),
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        totalPerDay: totalRevenue, 
      ),
      totalSoldProduct: totalSoldProduct,
      productTopSelling: topSelling,
      totalRevenue: totalRevenue,
      totalProfit: totalProfit,
      transactionCount: transactionCount,
      itemsSoldTotal: itemsSoldTotal,
    );
  }
}
