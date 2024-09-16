import 'package:database_final/model/product.dart';

class CartItem {
  Product product;
  int quantity;
  CartItem({required this.product, required this.quantity});
}
