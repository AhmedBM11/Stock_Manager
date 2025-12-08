import 'package:flutter/cupertino.dart';
import 'package:sat/data/models/bill_item_model.dart';

class BasketProvider extends ChangeNotifier {
  final List<BillItemModel> _items = [];

  // Expose items as unmodifiable list
  List<BillItemModel> get items => List.unmodifiable(_items);

  // Get quantity of a specific product
  int getQuantity(String productId) {
    final index = _items.indexWhere((p) => p.productId == productId);
    if (index >= 0) return _items[index].quantity;
    return 0;
  }

  // Add a product to the basket
  void addProduct(BillItemModel product) {
    final index = _items.indexWhere((p) => p.productId == product.productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
    } else {
      _items.add(product.copyWith(quantity: 1));
    }
    notifyListeners();
  }

  // Remove/decrease quantity of a product
  void removeProduct(String productId) {
    final index = _items.indexWhere((p) => p.productId == productId);
    if (index >= 0) {
      final currentQty = _items[index].quantity;
      if (currentQty > 1) {
        _items[index] = _items[index].copyWith(quantity: currentQty - 1);
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Increase quantity of a product
  void increase(String productId) {
    final index = _items.indexWhere((p) => p.productId == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
      notifyListeners();
    }
  }

  // Decrease quantity of a product
  void decrease(String productId) {
    final index = _items.indexWhere((p) => p.productId == productId);
    if (index >= 0) {
      final currentQty = _items[index].quantity;
      if (currentQty > 1) {
        _items[index] = _items[index].copyWith(quantity: currentQty - 1);
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Calculate total price
  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  // Clear basket
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
