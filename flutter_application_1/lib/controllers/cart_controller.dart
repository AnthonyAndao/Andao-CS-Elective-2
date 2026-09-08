import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

/// State controller managing shopping cart items, total counts, and prices.
///
/// Extends [ChangeNotifier] so widgets listening via [CartScope] or
/// [AnimatedBuilder] update automatically when cart contents change.
class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  /// Unmodifiable view of items currently in the cart.
  List<CartItem> get items => List.unmodifiable(_items);

  /// Total count of all items (sum of quantities across products).
  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Grand total price of all items in the cart.
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  /// Formatted total price string with currency symbol.
  String get formattedTotalPrice => '₱${_withThousandsSeparator(totalPrice)}';

  /// Returns true if the cart is completely empty.
  bool get isEmpty => _items.isEmpty;

  /// Adds [product] to the cart with the specified [quantity].
  /// If product is already in cart, updates quantity.
  void addToCart(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  /// Increments quantity for a specific product ID.
  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// Decrements quantity for a specific product ID. If quantity reaches 0,
  /// removes the item from the cart.
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Explicitly sets quantity for a product ID. If <= 0, removes item.
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  /// Removes an item completely from the cart.
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Clears all items from the cart (used after checkout).
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  static String _withThousandsSeparator(double value) {
    final wholeNumber = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < wholeNumber.length; i++) {
      final positionFromEnd = wholeNumber.length - i;
      buffer.write(wholeNumber[i]);
      final isThousandsBoundary = positionFromEnd > 1 && (positionFromEnd - 1) % 3 == 0;
      if (isThousandsBoundary) buffer.write(',');
    }
    return buffer.toString();
  }
}
