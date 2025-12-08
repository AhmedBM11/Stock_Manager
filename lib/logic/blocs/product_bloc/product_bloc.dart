import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sat/data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productRepository.searchProducts(event.storeId,event.query??"",event.category??"");
        final categories = await productRepository.getCategories(event.storeId);
        emit(ProductLoaded(products,categories));
      } catch (e) {
        emit(ProductError('Failed to load products: $e'));
      }
    });

    on<AddProductEvent>((event, emit) async {
      try {
        await productRepository.addProduct(event.storeId, event.product);
        add(LoadProducts(storeId: event.storeId));
      } catch (e) {
        emit(ProductError('Failed to add product: $e'));
      }
    });

    on<UpdateProductEvent>((event, emit) async {
      try {
        await productRepository.updateProduct(event.storeId, event.productId, event.data);
        add(LoadProducts(storeId: event.storeId));
      } catch (e) {
        emit(ProductError('Failed to update product: $e'));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      try {
        await productRepository.deleteProduct(event.storeId, event.productId);
        add(LoadProducts(storeId: event.storeId));
      } catch (e) {
        emit(ProductError('Failed to delete product: $e'));
      }
    });
  }
}
