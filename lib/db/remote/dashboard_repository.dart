import 'dart:convert';

import 'package:warungpakwardi/constant/api.dart';
import 'package:warungpakwardi/models/Dashboard.dart';
import 'package:warungpakwardi/models/ResponseAPI.dart';
import 'package:http/http.dart' as http;
import 'package:warungpakwardi/models/ResponseErrorAPI.dart';

class DashboardRepository {
  Future<ResponseAPI<Dashboard>> fetchSummariesDataUser(String token) async {
    final url = Uri.parse(dashboardSummariesApi);

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
        final dashboard = Dashboard.fromJson(data['data']);

        return ResponseAPI<Dashboard>(
          message: data['message'],
          data: dashboard,
        );
      } else {
        print('error di sini');
        throw ResponseErrorAPI(message: data['message']);
      }
    } catch (e) {
      print(e);
      throw ResponseErrorAPI(message: 'Terjadi kesalahan: $e');
    }
  }
}
