import 'package:flutter/material.dart';
import 'cart_controller.dart';

/// Provides access to the app's single [CartController] from anywhere in the widget
/// tree via `CartScope.of(context)`.
class CartScope extends InheritedNotifier<CartController> {
  const CartScope({
    super.key,
    required CartController controller,
    required super.child,
  }) : super(notifier: controller);

  static CartController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope not found in widget tree');
    return scope!.notifier!;
  }
}
