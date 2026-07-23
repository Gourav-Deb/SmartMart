import 'package:flutter/foundation.dart';
import '../data/app_data.dart';

class CartItem {
  final ProductItem product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount {
    double sum = 0;
    for (final item in _items) {
      final price = double.tryParse(
            item.product.price.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          0;
      sum += price * item.quantity;
    }
    return sum;
  }

  void add(ProductItem product) {
    final index = _items.indexWhere((e) => e.product.name == product.name);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void remove(ProductItem product) {
    final index = _items.indexWhere((e) => e.product.name == product.name);
    if (index < 0) return;
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int quantityOf(ProductItem product) {
    final index = _items.indexWhere((e) => e.product.name == product.name);
    return index >= 0 ? _items[index].quantity : 0;
  }
}

final cartController = CartController();
