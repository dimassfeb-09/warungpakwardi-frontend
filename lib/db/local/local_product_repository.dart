import 'package:sqflite/sqflite.dart';
import 'package:warungpakwardi/db/local/database_helper.dart';
import 'package:warungpakwardi/models/Product.dart';

class LocalProductRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // CREATE / REPLACE
  Future<void> insertProduct(Product product) async {
    final db = await _dbHelper.database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // BATCH INSERT (for sync pull)
  Future<void> insertProductsBatch(List<Product> products) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (var product in products) {
      batch.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // READ ALL (not deleted)
  Future<List<Product>> fetchAllProducts() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'products',
      where: 'is_deleted = ?',
      whereArgs: [0],
      orderBy: 'name ASC',
    );
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  // READ by ID
  Future<Product?> fetchProductById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query('products', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Product.fromMap(maps.first) : null;
  }

  // UPDATE
  Future<void> updateProduct(Product product) async {
    final db = await _dbHelper.database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Update Stock Manual (Atomic update for transactions)
  Future<void> updateProductStockManual(String id, num newStock) async {
    final db = await _dbHelper.database;
    await db.update(
      'products',
      {'stock': newStock},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // SOFT DELETE
  Future<void> softDeleteProduct(String id) async {
    final db = await _dbHelper.database;
    await db.update(
      'products',
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Ambil data belum tersinkronisasi
  Future<List<Product>> fetchUnsyncedProducts() async {
    final db = await _dbHelper.database;
    final maps = await db.query('products', where: 'is_synced = ?', whereArgs: [0]);
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  // Tandai sudah sync
  Future<void> markAsSynced(String id) async {
    final db = await _dbHelper.database;
    await db.update('products', {'is_synced': 1}, where: 'id = ?', whereArgs: [id]);
  }

  // CHECK UNIQUE NAME
  Future<bool> isProductNameDuplicate(String name, {String? excludeId}) async {
    final db = await _dbHelper.database;
    String whereClause = 'name = ? COLLATE NOCASE AND is_deleted = 0';
    List<dynamic> whereArgs = [name.trim()];

    if (excludeId != null) {
      whereClause += ' AND id != ?';
      whereArgs.add(excludeId);
    }

    final result = await db.query(
      'products',
      where: whereClause,
      whereArgs: whereArgs,
    );
    return result.isNotEmpty;
  }
}
