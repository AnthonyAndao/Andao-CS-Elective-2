import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/auth_controller.dart';
import 'controllers/auth_scope.dart';
import 'controllers/cart_controller.dart';
import 'controllers/cart_scope.dart';
import 'controllers/product_controller.dart';
import 'controllers/product_scope.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nsixzjbsekwwbputcgyu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
        '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5zaXh6amJzZWt3d2JwdXRjZ3l1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTQyMzc4MjUsImV4cCI6MjEwOTgxMzgyNX0'
        '.1v2noVPypq_Qch7SQFf62j0BQrBXEeNhFfHLFqizKv4',
  );

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
  late final ProductController _productController;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _cartController = CartController();
    _productController = ProductController();
    _authController = AuthController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    _cartController.dispose();
    _productController.dispose();
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _themeController,
      child: AuthScope(
        controller: _authController,
        child: CartScope(
          controller: _cartController,
          child: ProductScope(
            controller: _productController,
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
        ),
      ),
    );
  }
}

