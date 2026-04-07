import 'package:warungpakwardi/db/local/database_helper.dart';
import 'package:warungpakwardi/models/Dashboard.dart';
import 'package:warungpakwardi/models/Product.dart';

class LocalDashboardRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<Dashboard> fetchDashboardData() async {
    final db = await _dbHelper.database;

    // 1. Calculate Revenue and Total Transactions
    final transactionResult = await db.rawQuery('''
      SELECT SUM(total_price) as revenue,
             COUNT(*) as count
      FROM transactions
    ''');
    final revenue = (transactionResult.first['revenue'] as num?)?.toInt() ?? 0;
    final totalTransactions = transactionResult.first['count'] as int? ?? 0;

    // 2. Count Total Active Products
    final productCountResult = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM products
      WHERE is_deleted = 0
    ''');
    final totalProducts = productCountResult.first['count'] as int? ?? 0;

    // 3. Get Low Stock Products (threshold < 10)
    final lowStockResult = await db.query(
      'products',
      where: 'is_deleted = 0 AND stock < ?',
      whereArgs: [10],
      limit: 5,
    );
    final productsLowStock = lowStockResult.map((m) => Product.fromMap(m)).toList();

    return Dashboard(
      revenue: revenue,
      totalTransaction: totalTransactions,
      totalProduct: totalProducts,
      productLowStock: productsLowStock,
    );
  }
}
