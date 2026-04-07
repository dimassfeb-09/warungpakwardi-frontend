import 'package:sqflite/sqflite.dart';
import 'package:warungpakwardi/db/local/database_helper.dart';
import 'package:warungpakwardi/models/Transaction.dart' as model;
import 'package:warungpakwardi/models/TransactionDetail.dart';
import 'package:warungpakwardi/models/TransactionItem.dart';

class LocalTransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // CREATE TRANSACTION (with items in one batch)
  Future<void> insertTransaction(
    model.Transaction transaction,
    List<TransactionItem> items,
  ) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      // 1. Insert Transaction
      await txn.insert(
        'transactions',
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // 2. Insert Items
      for (var item in items) {
        await txn.insert(
          'transaction_items',
          item.toMap(transaction.transactionId),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  // BATCH INSERT (for sync pull)
  Future<void> insertTransactionsBatch(List<model.Transaction> transactions) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (var t in transactions) {
      batch.insert(
        'transactions',
        t.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // READ ALL
  Future<List<model.Transaction>> fetchAllTransactions() async {
    final db = await _dbHelper.database;
    final maps = await db.query('transactions', orderBy: 'transaction_date DESC');
    return maps.map((m) => model.Transaction.fromMap(m)).toList();
  }

  // READ BY DATE RANGE
  Future<List<model.Transaction>> fetchTransactionsByDateRange(DateTime start, DateTime end) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'transactions',
      where: 'transaction_date >= ? AND transaction_date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'transaction_date DESC',
    );
    return maps.map((m) => model.Transaction.fromMap(m)).toList();
  }

  // READ DETAIL BY ID
  Future<TransactionDetail?> fetchTransactionById(String transactionId) async {
    final db = await _dbHelper.database;

    // 1. Get Transaction
    final tMaps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [transactionId],
    );
    if (tMaps.isEmpty) return null;

    final transaction = model.Transaction.fromMap(tMaps.first);

    // 2. Get Items
    final iMaps = await db.query(
      'transaction_items',
      where: 'transaction_id = ?',
      whereArgs: [transactionId],
    );

    final items = iMaps.map((m) => TransactionItem.fromMap(m)).toList();

    return TransactionDetail(
      transactionId: transaction.transactionId,
      transactionDate: transaction.transactionDate,
      items: items,
      subtotal: transaction.totalPrice,
      total: transaction.totalPrice,
    );
  }

  // Ambil data belum tersinkronisasi
  Future<List<model.Transaction>> fetchUnsyncedTransactions() async {
    final db = await _dbHelper.database;
    final maps = await db.query('transactions', where: 'is_synced = ?', whereArgs: [0]);
    return maps.map((m) => model.Transaction.fromMap(m)).toList();
  }

  // Tandai sudah sync
  Future<void> markAsSynced(String transactionId) async {
    final db = await _dbHelper.database;
    await db.update('transactions', {'is_synced': 1}, where: 'id = ?', whereArgs: [transactionId]);
  }

  // DELETE TRANSACTION
  Future<void> deleteTransaction(String transactionId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [transactionId],
    );
  }
}
