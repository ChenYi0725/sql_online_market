class Product {
  int id;
  int merchantId;
  String name;
  String description;
  String base64Image;
  double price;
  int quantity;
  String category;
  String addData;
  String status;

  Product({
    required this.id,
    required this.merchantId,
    required this.name,
    required this.description,
    required this.base64Image,
    required this.price,
    required this.quantity,
    required this.category,
    required this.addData,
    required this.status,
  });
}
