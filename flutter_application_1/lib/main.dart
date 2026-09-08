import 'package:flutter/material.dart';

import 'controllers/cart_controller.dart';
import 'controllers/cart_scope.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_scope.dart';

void main() {
  runApp(const SoleMateApp());
}

/// Root widget. This is a [StatefulWidget] because it owns the
/// [ThemeController] and [CartController] instances for the whole app's lifetime.
class SoleMateApp extends StatefulWidget {
  const SoleMateApp({super.key});

  @override
  State<SoleMateApp> createState() => _SoleMateAppState();
}

class _SoleMateAppState extends State<SoleMateApp> {
  late final ThemeController _themeController;
  late final CartController _cartController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _cartController = CartController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _themeController,
      child: CartScope(
        controller: _cartController,
        child: AnimatedBuilder(
          animation: _themeController,
          builder: (context, _) {
            return MaterialApp.router(
              title: 'SoleMate',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: _themeController.mode,
              routerConfig: appRouter,
            );
          },
        ),
      ),
    );
  }
}

