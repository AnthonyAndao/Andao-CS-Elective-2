import 'package:flutter/material.dart';
import 'product_controller.dart';

/// Provides the app's single [ProductController] instance to any widget in the
/// tree via `ProductScope.of(context)`.
///
/// Backed by [InheritedNotifier] so that descendants that call
/// `ProductScope.of(context)` inside a [ListenableBuilder] rebuild
/// automatically when the controller notifies.
class ProductScope extends InheritedNotifier<ProductController> {
  const ProductScope({
    super.key,
    required ProductController controller,
    required super.child,
  }) : super(notifier: controller);

  static ProductController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ProductScope>();
    assert(scope != null, 'ProductScope not found in widget tree');
    return scope!.notifier!;
  }
}

