import 'package:go_router/go_router.dart';

import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';

/// All app routing lives here, in one place, using go_router (Navigation 2.0).
///
/// Registered routes:
///   /            -> HomeScreen (product grid)
///   /product/:id -> ProductDetailScreen (product info & add to cart)
///   /cart        -> CartScreen (cart items & quantity controls)
///   /checkout    -> CheckoutScreen (order summary & confirmation)
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
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
  ],
);
