import 'package:database_final/pages/insert_product_page.dart';
import 'package:database_final/pages/main_page.dart';
import 'package:database_final/pages/product_page.dart';
import 'package:database_final/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../controller/database_controller.dart';
import '../model/product.dart';
import '../model/product_preview.dart';
import 'cart_page.dart';
import 'login_page.dart';

class StorePage extends StatefulWidget {
  final dynamic user;
  final int sellerId;
  late String merchantName;

  StorePage({Key? key, required this.sellerId, this.user}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late TextEditingController searchController;
  late List<Product> products;
  DatabaseController databaseController = DatabaseController();

  @override
  void initState() {
    super.initState();
    products = [];
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    products = await databaseController.fetchProductByMerchant(widget.sellerId);

    print(products);
    _loadSellerName();
    setState(() {
      print("products:${products.length}");
    });
  }

  Future<void> _loadSellerName() async {
    try {
      widget.merchantName = await _getSellerName(widget.sellerId);
      setState(() {});
    } catch (error) {
      print('Error fetching seller name: $error');
    }
  }

  Future<String> _getSellerName(id) async {
    var userData = await databaseController.singleUserData(id);
    return userData['user_name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(user: widget.user),
              ),
            );
          },
          child: Icon(Icons.shop),
        ),
        title: const Text('Main Page'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(user: widget.user),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              if (widget.user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(user: widget.user),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.perm_identity),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            color: Colors.orangeAccent[100],
            child: Center(
              child: Text(
                "${widget.merchantName}'s shop",
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.9,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          user: widget.user,
                          product: product,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ProductPreview(product: product),
                  ),
                );
              },
            ),
          ),
          if (widget.user != Null)
            if (widget.user.id == widget.sellerId)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InsertProductPage(user: widget.user),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orangeAccent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text(
                  'Add Product',
                  style: TextStyle(color: Colors.white),
                ),
              )
        ],
      ),
    );
  }
}
