import 'package:sat/data/models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<String> categories;
  ProductLoaded(this.products,this.categories);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
