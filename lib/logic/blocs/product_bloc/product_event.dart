import 'package:sat/data/models/product_model.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {
  final String? query;
  final String? category;
  final String storeId;
  LoadProducts({required this.storeId, this.query, this.category});
}

class AddProductEvent extends ProductEvent {
  final String storeId;
  final ProductModel product;
  AddProductEvent({
    required this.storeId,
    required this.product,
  });
}

class UpdateProductEvent extends ProductEvent {
  final String storeId;
  final String productId;
  final Map<String, dynamic> data;
  UpdateProductEvent({
    required this.storeId,
    required this.productId,
    required this.data,
  });
}

class DeleteProductEvent extends ProductEvent {
  final String storeId;
  final String productId;
  DeleteProductEvent({
    required this.storeId,
    required this.productId,
  });
}
