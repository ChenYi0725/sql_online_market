import 'dart:convert';

import 'package:database_final/pages/store_page.dart';
import 'package:flutter/material.dart';

import '../controller/database_controller.dart';
import '../model/product.dart';
import '../pages/cart_page.dart';
import '../pages/login_page.dart';
import '../pages/product_page.dart';
import '../pages/profile_page.dart';
import '../pages/search_result_page.dart';
import '../model/product_preview.dart';

class MainPage extends StatefulWidget {
  final dynamic user;
  const MainPage({Key? key, this.user}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late TextEditingController searchController;
  late List<Product> products;
  DatabaseController databaseController = DatabaseController();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    products = [];
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    products = await databaseController.getAllProducts();
    setState(() {});
  }

  void _searchProducts(String searchText) {
    List<Product> searchResults = [];

    for (Product product in products) {
      if (product.name.toLowerCase().contains(searchText.toLowerCase())) {
        searchResults.add(product);
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultPage(
          user: widget.user,
          searchText: searchText,
          searchResult: searchResults,
        ),
      ),
    );
    // if (widget.user != null) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => SearchResultPage(
    //         user: widget.user,
    //         searchText: searchText,
    //         searchResult: searchResults,
    //       ),
    //     ),
    //   );
    // } else {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const LoginPage(),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _loadProducts(); // 當 pop 時重新載入產品
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  _loadProducts(); // 重新載入產品
                },
                icon: const Icon(Icons.shop),
              );
            },
          ),
          title: const Text('Main Page'),
          backgroundColor: Colors.orange,
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    if (widget.user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StorePage(
                            user: widget.user,
                            sellerId: widget.user.id,
                          ),
                        ),
                      ).then((_) => _loadProducts()); // 回來時重新載入產品
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.storefront_outlined),
                );
              },
            ),
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    if (widget.user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(user: widget.user),
                        ),
                      ).then((_) => _loadProducts()); // 回來時重新載入產品
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.shopping_cart),
                );
              },
            ),
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    if (widget.user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(user: widget.user),
                        ),
                      ).then((_) => _loadProducts()); // 回來時重新載入產品
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
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'search',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      String searchText = searchController.text;
                      _searchProducts(searchText);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
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
                        ).then((_) => _loadProducts()); // 回來時重新載入產品
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ProductPreview(product: product),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
