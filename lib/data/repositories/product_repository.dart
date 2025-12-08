import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //get store's products
  Future<List<ProductModel>> getProducts(String storeId) async {
    final querySnapshot = await _db
        .collection('stores')
        .doc(storeId)
        .collection('products')
        .get();
    return querySnapshot.docs
        .map((doc) => ProductModel.fromDocument(doc))
        .toList();
  }

  Future<List<ProductModel>> searchProducts(String storeId, String query, String category) async {
    if (query.isEmpty && (category.isEmpty || category == "All_Products")) {
      return getProducts(storeId); // fallback: return all products
    }

    final querySnapshot = await _db
        .collection('stores')
        .doc(storeId)
        .collection('products')
        .get();

    var products = querySnapshot.docs
        .map((doc) => ProductModel.fromDocument(doc))
        .toList();

    if (query.isNotEmpty) {
      products = products.where((product) {
        final name = product.name.toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();}

    if (category.isNotEmpty) {
      products = products.where((product) {
        final ctg = product.category;
        return ctg == category ;
      }).toList();}

    return products;
  }

  //Get unique categories from products
  Future<List<String>> getCategories(String storeId) async {
    final querySnapshot = await _db
        .collection('stores')
        .doc(storeId)
        .collection('products')
        .get();

    // Use a Set to avoid repetition
    final Set<String> categories = {};

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      if (data.containsKey("category") && data["category"] != null) {
        categories.add(data["category"].toString());
      }
    }

    return categories.toList();
  }

  //add product to a store
  Future<void> addProduct(String storeId, ProductModel product) async {
    await _db
        .collection('stores')
        .doc(storeId)
        .collection('products')
        .add(product.toMap());
  }

  //update store's product
  Future<void> updateProduct(String storeId, String productId, Map<String, dynamic> data) async {
    await _db
        .collection('stores')
        .doc(storeId)
        .collection('products')
        .doc(productId)
        .update(data);
  }

  //delete store's product
  Future<void> deleteProduct(String storeId, String productId) async {
    await _db
        .collection('stores')
        .doc(storeId)
        .collection('products')
        .doc(productId)
        .delete();
  }

  //get product by Id
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _db.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromDocument((doc.data()!..['id'] = doc.id) as DocumentSnapshot<Object?>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
