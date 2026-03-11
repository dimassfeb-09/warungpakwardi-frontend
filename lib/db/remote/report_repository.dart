import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warungpakwardi/constant/api.dart';
import 'package:warungpakwardi/models/ResponseAPI.dart';
import 'package:warungpakwardi/models/ResponseErrorAPI.dart';
import 'package:warungpakwardi/models/TransactionReport.dart';

class ReportRepository {
  // FETCH
  Future<ResponseAPI<TransactionReport>> fetchReport(String token) async {
    final url = Uri.parse(reportTransactionApi);

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
        final TransactionReport report = TransactionReport.fromJson(
          data['data'],
        );
        return ResponseAPI<TransactionReport>(
          message: data['message'],
          data: report,
        );
      } else {
        throw ResponseErrorAPI(message: data['message']);
      }
    } catch (e) {
      print("ada error 3 $e");
      if (e is ResponseErrorAPI) {
        print(e.message);
        rethrow;
      }
      throw ResponseErrorAPI(message: 'Terjadi kesalahan: $e');
    }
  }
}
