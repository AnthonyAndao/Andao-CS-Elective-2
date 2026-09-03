// Basic smoke test for AURELIA.
//
// The default `flutter create` template ships a counter-app test that
// references `MyApp` — that class doesn't exist in this project anymore
// (our root widget is `AureliaApp`), so that test was replaced.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurelia_shop/main.dart';

void main() {
  testWidgets('Home screen renders AppBar title and product grid',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AureliaApp());
    await tester.pumpAndSettle();

    // AppBar wordmark shows up.
    expect(find.text('AURELIA'), findsOneWidget);

    // The product grid (now a CustomScrollView/SliverGrid) is rendered.
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
  });

  testWidgets('Theme toggle button switches the icon', (WidgetTester tester) async {
    await tester.pumpWidget(const AureliaApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
  });
}
