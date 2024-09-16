import 'package:database_final/pages/product_page.dart';
import 'package:database_final/pages/profile_page.dart';
import 'package:flutter/material.dart';
import '../model/cart_item.dart';
import '../model/cart_item_view.dart';
import '../model/product.dart';
import '../model/user.dart';
import 'login_page.dart';
import '../controller/database_controller.dart';

class CartPage extends StatefulWidget {
  final User user;

  const CartPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final DatabaseController databaseController = DatabaseController();
  late List<CartItem> cartItems;

  void _removeCartItem(int productId) {
    setState(() {
      cartItems.removeWhere((item) => item.product.id == productId);
    });
    databaseController.deleteSingleCartItem(widget.user.id, productId);
  }

  @override
  void initState() {
    super.initState();
    cartItems = [];
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    cartItems = await databaseController.getUserCart(widget.user.id);
    setState(() {
      print("products:${cartItems.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
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
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                CartItem cartItem = cartItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          user: widget.user,
                          product: cartItem.product,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CartItemView(
                      cartItem: CartItem(
                        product: cartItem.product,
                        quantity: cartItem.quantity,
                      ),
                      user: widget.user,
                      onRemove: _removeCartItem,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                databaseController.cleanCartItem(widget.user.id);
                //把購物車內容打包成訂單(未完成)
                Navigator.pop(context);
                print('Checkout button pressed');
              },
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
