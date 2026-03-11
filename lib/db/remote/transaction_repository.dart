import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:warungpakwardi/models/ResponseErrorAPI.dart';
import 'package:warungpakwardi/models/TransactionDetail.dart';

import '../../constant/api.dart';
import '../../models/CreateTransaction.dart';
import '../../models/ResponseAPI.dart';
import '../../models/Transaction.dart';

class TransactionRepository {
  Future<ResponseAPI<List<Transaction>>> fetchTransaction(String token) async {
    final url = Uri.parse('$transactionApi/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> productListJson = data['data'];
        final List<Transaction> products =
            productListJson.map((json) => Transaction.fromJson(json)).toList();

        return ResponseAPI<List<Transaction>>(
          message: data['message'],
          data: products,
        );
      } else {
        throw ResponseErrorAPI(message: data['message']);
      }
    } catch (e) {
      if (e is ResponseErrorAPI) {
        rethrow;
      } else {
        throw ResponseErrorAPI(message: 'Terjadi kesalahan: $e');
      }
    }
  }

  Future<ResponseAPI<TransactionDetail>> fetchTransactionById(
    String transactionId,
    String token,
  ) async {
    final url = Uri.parse('$transactionApi/$transactionId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final transactionDetail = TransactionDetail.fromJson(data['data']);

        return ResponseAPI<TransactionDetail>(
          message: data['message'],
          data: transactionDetail,
        );
      } else {
        throw ResponseErrorAPI(message: data['message']);
      }
    } catch (e) {
      if (e is ResponseErrorAPI) {
        rethrow;
      } else {
        throw ResponseErrorAPI(message: 'Terjadi kesalahan: $e');
      }
    }
  }

  Future<ResponseAPI<Transaction>> createTransaction(
    String token,
    List<CreateTransaction> transactions,
  ) async {
    final url = Uri.parse('$transactionApi/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(transactions.map((t) => t.toJson()).toList()),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final transaction = Transaction.fromJson(data['data']);
        return ResponseAPI<Transaction>(
          message: data['message'],
          data: transaction,
        );
      } else if (response.statusCode == 404) {
        throw ResponseErrorAPI(message: "Produk tidak ditemukan.");
      } else {
        throw ResponseErrorAPI(message: data['message']);
      }
    } catch (e) {
      if (e is ResponseErrorAPI) {
        rethrow;
      } else {
        throw ResponseErrorAPI(message: 'Terjadi kesalahan: $e');
      }
    }
  }
}
