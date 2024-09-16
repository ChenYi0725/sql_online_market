import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'model/product.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  Future<List> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/get_users_data'));
    if (response.statusCode == 200) {
      print("success load users");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/get_products_data'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<dynamic> fetchSingleProductId(int productId) async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/get_product/$productId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load productId data');
    }
  }

  Future<dynamic> fetchSingleUser(int userId) async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/get_user/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<dynamic> fetchCart(int userId) async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/get_cart/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load cart data');
    }
  }

  Future<dynamic> fetchProductByMerchant(int merchantId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_product_by_merchantId/$merchantId'),
    );
    print('response${response.body}'); // print伺服器返回的數據
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('Error decoding JSON: $e');
        throw Exception('Error decoding JSON');
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }

  Future<void> addUserData(
    String name,
    String email,
    String password,
    String phone,
    String role,
    String registrationDate,
  ) async {
    final url = '$baseUrl/register_users';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': role,
        'registration_date': registrationDate,
      },
    );

    if (response.statusCode == 201) {
      print('Data inserted successfully');
    } else {
      print('Failed to insert data');
    }
  }

  addCartItem(int userId, int productId, int quantity) async {
    String userIdString = userId.toString();
    String productIdString = productId.toString();
    String quantityString = quantity.toString();

    final url = '$baseUrl/add_to_cart/$userIdString';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'user_id': userIdString,
        'product_id': productIdString,
        'quantity': quantityString,
      },
    );

    if (response.statusCode == 201) {
      print('Data inserted successfully');
    } else {
      print('Failed to insert data');
    }
  }

  Future<void> deleteSingleCartItem(int userId, int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete_cart'), // 更換成您的服務器 IP 地址
        body: {'userId': userId.toString(), 'productId': productId.toString()},
      );
      if (response.statusCode == 200) {
        print('Cart item deleted successfully');
      } else {
        print('Failed to delete cart item');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> cleanCartItem(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/clean_cart'), // 更換成您的服務器 IP 地址
        body: {'userId': userId.toString()},
      );
      if (response.statusCode == 200) {
        print('Cart item deleted successfully');
      } else {
        print('Failed to delete cart item');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> insertProduct(
      int merchantId,
      String name,
      String description,
      String image,
      int price,
      String quantity,
      String category,
      String addedData,
      String status) async {
    final url = '$baseUrl/add_product/$merchantId';

    final response = await http.post(Uri.parse(url), body: {
      'merchantId': merchantId.toString(),
      'name': name,
      'description': description,
      'image': image,
      'price': price.toString(),
      'quantity': quantity.toString(),
      'category': category,
      'addedData': addedData,
      'status': status,
    });

    if (response.statusCode == 201) {
      print('Data inserted successfully');
    } else {
      print('Failed to insert data');
    }
  }
// 添加更多 API 調用方法
}
