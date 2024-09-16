import 'dart:convert';
import 'dart:typed_data';
import 'package:database_final/model/product.dart';
import 'package:flutter/material.dart';

class ProductPreview extends StatelessWidget {
  Product product;

  ProductPreview({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List decodedImage = base64Decode(product.base64Image);

    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 80, // 設置容器寬度
      height: 300, // 設置容器高度
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // 圖片
          Container(
            width: 150,
            height: 150, // 設置圖片高度
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(decodedImage),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(height: 8.0),
          // 名稱、剩餘數量、價格
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('價格: \$${product.price.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('剩餘數量: ${product.quantity}'),
                const SizedBox(height: 8),
                Text('分類: ${product.category}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
