import 'package:database_final/model/product.dart';
import 'package:database_final/pages/product_page.dart';
import 'package:flutter/material.dart';
import '../model/product_preview.dart';
import '../model/user.dart';
import 'login_page.dart';

class SearchResultPage extends StatelessWidget {
  final String searchText;
  final List<Product> searchResult;
  final dynamic user;
  const SearchResultPage({
    Key? key,
    required this.searchText,
    required this.searchResult,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Result of "${searchText}" '),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.9,
            ),
            itemCount: searchResult.length,
            itemBuilder: (context, index) {
              Product product = searchResult[index];
              return GestureDetector(
                onTap: () {
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          user: user,
                          product: product,
                        ),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ProductPreview(product: product),
                ),
              );
            },
          ),
        ));
  }
}
