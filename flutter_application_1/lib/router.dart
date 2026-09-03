import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';

/// All app routing lives here, in one place, using go_router
/// (Navigation 2.0) instead of imperative Navigator.push calls.
///
/// Routes so far:
///   /                    -> HomeScreen (product grid)
///   /product/:id         -> ProductDetailScreen (empty/placeholder for now)
///
/// Cart and Checkout routes will be added once those screens exist.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      name: 'productDetail',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
  ],
);
