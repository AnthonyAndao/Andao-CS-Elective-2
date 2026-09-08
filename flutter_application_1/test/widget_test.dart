// Basic smoke and user flow tests for SoleMate.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sole_mate/main.dart';
import 'package:sole_mate/widgets/product_card.dart';

void main() {
  testWidgets('Home screen renders AppBar title and product grid',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SoleMateApp());
    await tester.pumpAndSettle();

    // AppBar wordmark shows up.
    expect(find.text('SoleMate'), findsOneWidget);

    // The product grid is rendered.
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
  });

  testWidgets('Theme toggle button switches the icon', (WidgetTester tester) async {
    await tester.pumpWidget(const SoleMateApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
  });

  testWidgets('Complete checkout user flow executes without error', (WidgetTester tester) async {
    await tester.pumpWidget(const SoleMateApp());
    await tester.pumpAndSettle();

    // 1. Tap on first product card in grid to navigate to details
    final firstProductCard = find.byType(ProductCard).first;
    expect(firstProductCard, findsOneWidget);
    await tester.tap(firstProductCard);
    await tester.pumpAndSettle();

    // 2. Tap "Add 1 to Cart"
    final addToCartBtn = find.text('Add 1 to Cart');
    expect(addToCartBtn, findsOneWidget);
    await tester.tap(addToCartBtn);
    await tester.pumpAndSettle();

    // 3. Open Cart screen
    final cartIcon = find.byIcon(Icons.shopping_bag_outlined).last;
    await tester.tap(cartIcon);
    await tester.pumpAndSettle();

    // Verify Cart screen renders item and Proceed to Checkout CTA
    expect(find.text('My Cart'), findsOneWidget);
    final checkoutBtn = find.text('Proceed to Checkout');
    expect(checkoutBtn, findsOneWidget);

    // 4. Tap Proceed to Checkout
    await tester.tap(checkoutBtn);
    await tester.pumpAndSettle();

    // 5. Verify Checkout Screen renders Order Confirmed! without exception
    expect(find.text('Order Confirmed!'), findsOneWidget);
    expect(find.text('Continue Shopping'), findsOneWidget);
  });
}
