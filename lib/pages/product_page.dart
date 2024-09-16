import 'dart:convert';
import 'dart:typed_data';
import 'package:database_final/pages/store_page.dart';
import 'package:flutter/material.dart';
import '../controller/database_controller.dart';
import '../model/product.dart';
import 'cart_page.dart';
import 'login_page.dart';
import 'profile_page.dart';

class ProductPage extends StatefulWidget {
  final dynamic user;
  final Product product;
  const ProductPage({Key? key, this.user, required this.product})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int orderQuantity = 1;
  DatabaseController databaseController = DatabaseController();
  late String sellerName;
  void increaseQuantity() {
    setState(() {
      orderQuantity++;
    });
  }

  Future<void> _loadSellerName() async {
    try {
      String name = await _getSellerName(widget.product.merchantId);
      setState(() {
        sellerName = name;
      });
    } catch (error) {
      print('Error fetching seller name: $error');
    }
  }

  Future<String> _getSellerName(id) async {
    var userData = await databaseController.singleUserData(id);
    return userData['user_name'];
  }

  void decreaseQuantity() {
    if (orderQuantity > 1) {
      setState(() {
        orderQuantity--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSellerName();
  }

  @override
  Widget build(BuildContext context) {
    Uint8List decodedImage = base64Decode(widget.product.base64Image);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
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
            icon: const Icon(Icons.storefront_outlined),
          ),
          IconButton(
            onPressed: () {
              if (widget.user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(user: widget.user),
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
              //--
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 400,
                  width: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(decodedImage),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "\$${widget.product.price}",
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.product.description,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 75),
                    Text(
                      "Seller ID：${widget.product.merchantId}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        if (sellerName != null && widget.user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StorePage(
                                  sellerId: widget.product.merchantId,
                                  user: widget.user),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Seller name：${sellerName ?? 'Loading...'}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          onPressed: decreaseQuantity,
                          icon: Icon(Icons.remove),
                        ),
                        Text(
                          '$orderQuantity',
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: increaseQuantity,
                          icon: const Icon(Icons.add),
                        ),
                        const SizedBox(width: 25),
                        if (widget.user != null &&
                            widget.user.id != widget.product.merchantId)
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                        'Item successfully added to cart.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              databaseController.addToCart(widget.user.id,
                                  widget.product.id, orderQuantity);
                            },
                            child: Text('Add to cart'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Remaining amount：${widget.product.quantity}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
