import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'cart_item.dart';
import 'user.dart';
import 'package:database_final/controller/database_controller.dart';

class CartItemView extends StatelessWidget {
  final CartItem cartItem;
  final User user;
  final Function(int) onRemove;

  CartItemView({
    required this.cartItem,
    required this.user,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List decodedImage = base64Decode(cartItem.product.base64Image);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          // 图片
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(decodedImage),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(width: 8.0),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('價格: \$${cartItem.product.price.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('分類: ${cartItem.product.category}'),
              ],
            ),
          ),
          SizedBox(width: 40.0),
          Text("數量：${cartItem.quantity}"),
          // 删除按钮
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              onRemove(cartItem.product.id);
            },
          ),
        ],
      ),
    );
  }
}
