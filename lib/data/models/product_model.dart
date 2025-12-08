import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final double? buyPrice;
  final double? sellPrice;
  final int? quantity;
  final String? imageUrl;
  final String? category;


  ProductModel({
    required this.id,
    required this.name,
    this.buyPrice,
    this.sellPrice,
    this.quantity,
    this.imageUrl,
    this.category,
  });

  //from firebase
  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? 'New Product',
      buyPrice: (data['firstPrice'] ?? 0).toDouble(),
      sellPrice: (data['finalPrice'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      imageUrl: data['imageUrl'] ?? 'https://img.freepik.com/premium-vector/product-line-concept-simple-line-icon-colored-illustration-product-symbol-flat-design-can-be-used-ui-ux_159242-4752.jpg',
      category: data['category'] ?? "All_Products",
    );
  }

  //to firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'firstPrice': buyPrice,
      'finalPrice': sellPrice,
      'quantity': quantity,
      'imageUrl': imageUrl=='https://via.placeholder.com/150'?'https://img.freepik.com/premium-vector/product-line-concept-simple-line-icon-colored-illustration-product-symbol-flat-design-can-be-used-ui-ux_159242-4752.jpg':imageUrl,
      'category': category??"All_Products",
    };
  }
}
