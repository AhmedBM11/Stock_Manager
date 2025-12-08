
class BillItemModel {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final String? imageUrl;

  BillItemModel({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl??"https://cdn-icons-png.flaticon.com/512/962/962863.png",
    };
  }

  BillItemModel copyWith({int? quantity}) {
    return BillItemModel(
      productId: productId,
      name: name,
      quantity: quantity ?? this.quantity,
      price: price,
      imageUrl: imageUrl
    );
  }

  factory BillItemModel.fromMap(Map<String, dynamic> map) {
    return BillItemModel(
      productId: map['productId'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }
}

