import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warungpakwardi/constant/api.dart';
import 'package:warungpakwardi/models/ResponseAPI.dart';
import 'package:warungpakwardi/models/ResponseErrorAPI.dart';

import '../../models/Product.dart';

class ProductRepository {
  // FETCH
  Future<ResponseAPI<List<Product>>> fetchProduct(String token) async {
    final url = Uri.parse(productApi);

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
        final List<Product> products =
            productListJson.map((json) => Product.fromJson(json)).toList();

        return ResponseAPI<List<Product>>(
          message: data['message'],
          data: products,
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

  // CREATE
  Future<ResponseAPI<Product>> createProduct(
    String token,
    Product product,
  ) async {
    final url = Uri.parse('$productApi/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(product.toJson()),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final Product newProduct = Product.fromJson(data['data']);

        return ResponseAPI<Product>(message: data['message'], data: newProduct);
      } else {
        throw ResponseErrorAPI(message: data['message']);
      }
    } catch (e) {
      if (e is ResponseErrorAPI) {
        rethrow;
      } else {
        print("ada error 2 $e");

        throw ResponseErrorAPI(message: 'Terjadi kesalahan: $e');
      }
    }
  }

  // UPDATE
  Future<ResponseAPI<Product>> updateProduct(
    String token,
    Product product,
  ) async {
    final url = Uri.parse('$productApi/${product.id}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(product.toJson()),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final updatedProduct = Product.fromJson(data['data']);

        return ResponseAPI<Product>(
          message: data['message'],
          data: updatedProduct,
        );
      } else {
        throw ResponseErrorAPI(message: data['message']);
      }
    } catch (e) {
      print("ada error 1 $e");
      throw ResponseErrorAPI(message: 'Terjadi kesalahan: $e');
    }
  }

  Future<ResponseAPI<void>> deleteProduct(
    String token,
    String productId,
  ) async {
    final url = Uri.parse('$productApi/$productId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return ResponseAPI<void>(message: data['message']);
      } else {
        throw ResponseErrorAPI(message: data['message']);
      }
    } catch (e) {
      if (e is ResponseErrorAPI) {
        print(e.message);
        rethrow;
      }
      throw ResponseErrorAPI(message: 'Terjadi kesalahan: $e');
    }
  }

  Future<void> syncToServer({
    required String token,
    required List<Product> localUnsyncedProducts,
  }) async {
    final url = Uri.parse('$baseUrl/product/sync');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(localUnsyncedProducts.map((e) => e.toJson()).toList()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to sync to server');
    }
  }

  Future<List<Product>> fetchUpdatedProducts({required String token}) async {
    final url = Uri.parse('$baseUrl/products/');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch updated products');
    }
  }
}
