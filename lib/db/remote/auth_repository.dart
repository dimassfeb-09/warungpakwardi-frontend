import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:warungpakwardi/models/Login.dart';
import 'package:warungpakwardi/models/ResponseErrorAPI.dart';

import '../../constant/api.dart';
import '../../models/Register.dart';
import '../../models/ResponseAPI.dart';
import '../../models/User.dart';

class AuthRepository {
  Future<ResponseAPI<void>> register(Register register) async {
    try {
      Uri url = Uri.parse("$baseUrl/auth/register");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(register.toJson()),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ResponseAPI<void>.fromJson(body, null);
      } else {
        throw body["message"] ?? "Register gagal";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI<String>> login(Login login) async {
    try {
      Uri url = Uri.parse("$baseUrl/auth/login");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(login.toJson()),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ResponseAPI<String>.fromJson(
          body,
          (data) => data['token'] as String,
        );
      } else {
        throw body["message"] ?? "Login gagal";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI<User>> me(String token) async {
    try {
      Uri url = Uri.parse("$baseUrl/auth/me");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ResponseAPI<User>.fromJson(body, (data) => User.fromJson(data));
      } else {
        throw ResponseErrorAPI(message: body['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
