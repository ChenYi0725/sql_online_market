import 'dart:convert';
import 'dart:io';
import 'package:database_final/model/cart_item.dart';
import 'package:postgres/postgres.dart';
import 'package:database_final/model/user.dart';
import 'package:database_final/api_service.dart';

import '../model/product.dart';

class DatabaseController {
  ApiService apiService = ApiService();
  String defaultImage =
      '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';
  Future<User?> userLogIn(String email, String password) async {
    try {
      final users = await apiService.fetchUsers(); // 等待 fetchUsers 函數完成並獲取用戶資料
      for (var user in users) {
        if (user['email'] == email && user['user_password'] == password) {
          // 符合資料的情況，建立一個 User 物件並返回
          return User(
            id: user['user_id'],
            name: user['user_name'],
            email: user['email'],
            phone: user['phone'],
            role: user['role'],
            registrationDate: user['registration_date'],
          );
        }
      }
      return null;
    } catch (e) {
      // 處理異常情況
      print('Error fetching user data: $e');
      return null;
    }
  }

  void userRegister(String name, String email, String password, String phone,
      String role, String registrationDate) async {
    await apiService.addUserData(
        name, email, password, phone, role, registrationDate);
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
    await apiService.insertProduct(merchantId, name, description, image, price,
        quantity, category, addedData, status);
  }

  void deleteSingleCartItem(int userId, int productId) async {
    await apiService.deleteSingleCartItem(userId, productId);
  }

  void cleanCartItem(int userId) async {
    await apiService.cleanCartItem(userId);
  }

  void addToCart(int userId, int productId, int quantity) async {
    await apiService.addCartItem(userId, productId, quantity);
  }

  Future<dynamic> singleUserData(userId) {
    final userData = apiService.fetchSingleUser(userId);
    return userData;
  }

  Future<dynamic> singleProductData(productId) {
    final productData = apiService.fetchSingleProductId(productId);
    return productData;
  }

  Future<List<CartItem>> getUserCart(int merchantId) async {
    List<CartItem> cartItemList = [];
    try {
      final products = await apiService.fetchCart(merchantId);

      for (var productData in products) {
        int productId = productData['product_id'];
        var oneProductData = await singleProductData(productId);

        Product product = Product(
          merchantId: oneProductData['merchant_id'] as int,
          id: oneProductData['product_id'] as int,
          name: oneProductData['product_name'] as String,
          description: oneProductData['product_description'] as String,
          base64Image: defaultImage, // 使用預設圖片
          price: double.parse(oneProductData['price'] as String),
          quantity: oneProductData['stock_quantity'] as int,
          category: oneProductData['category'] as String,
          addData: oneProductData['added_date'] as String,
          status: oneProductData['status'] as String,
        );

        CartItem cartItem = CartItem(
            product: product, quantity: productData['quantity']); // 修正此處的錯誤

        cartItemList.add(cartItem);
      }
    } catch (e) {
      print('Error fetching user cart: $e');
    }

    return cartItemList;
  }

  Future<List<Product>> fetchProductByMerchant(int merchantId) async {
    List<Product> productList = [];
    try {
      print("a");
      var products = await apiService.fetchProductByMerchant(merchantId);
      print("b");
      print(products);
      for (var productData in products) {
        Product product = Product(
          merchantId: productData['merchant_id'] as int,
          id: productData['product_id'] as int,
          name: productData['product_name'] as String,
          description: productData['product_description'] as String,
          base64Image:
              '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',
          price: double.parse(productData['price']),
          quantity: productData['stock_quantity'] as int,
          category: productData['category'] as String,
          addData: productData['added_date'] as String,
          status: productData['status'] as String,
        );
        productList.add(product);
      }
    } catch (e) {
      // 處理異常情況
      print('Error fetching product data: $e');
    }
    print(productList);
    return productList;
  }

  Future<List<Product>> getAllProducts() async {
    List<Product> productList = [];
    try {
      final products = await apiService.fetchProducts();
      for (var productData in products) {
        Product product = Product(
          merchantId: productData['merchant_id'] as int,
          id: productData['product_id'] as int,
          name: productData['product_name'] as String,
          description: productData['product_description'] as String,
          base64Image:
              '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',
          price: double.parse(productData['price']),
          quantity: productData['stock_quantity'] as int,
          category: productData['category'] as String,
          addData: productData['added_date'] as String,
          status: productData['status'] as String,
        );
        productList.add(product);
      }
    } catch (e) {
      // 處理異常情況
      print('Error fetching product data: $e');
    }
    return productList;
  }
}
