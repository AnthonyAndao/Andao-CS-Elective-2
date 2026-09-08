import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/cart_scope.dart';
import '../models/cart_item.dart';
import '../theme/theme_scope.dart';
import '../widgets/product_image.dart';

/// Checkout Confirmation Screen.
///
/// Meets PDF requirements:
/// - Final screen after checkout.
/// - Reachable only after at least one item is in the cart (includes empty cart guard).
/// - Displays simple summary of: Cart items, Subtotal per item, Total price, and Confirmation message.
/// - Scaffold with AppBar on every screen.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _initialized = false;
  late List<CartItem> _checkoutItems;
  late double _checkoutTotal;
  late int _checkoutItemCount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final cartController = CartScope.of(context);
      _checkoutItems = List.from(cartController.items);
      _checkoutTotal = cartController.totalPrice;
      _checkoutItemCount = cartController.totalItemCount;
      _initialized = true;
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = ThemeScope.of(context);
    final cartController = CartScope.of(context);

    // Guard requirement: Reachable only after at least one item is in the cart
    if (_checkoutItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          actions: [
            IconButton(
              tooltip: themeController.isDark ? 'Light Mode' : 'Dark Mode',
              icon: Icon(
                themeController.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_outlined,
              ),
              onPressed: themeController.toggle,
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.remove_shopping_cart_outlined,
                  size: 56,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'No items in cart for checkout',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please add at least one product to your cart before proceeding to checkout.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.storefront_rounded),
                  label: const Text('Return to Shop'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        automaticallyImplyLeading: false, // Prevents accidental back to un-cleared cart
        actions: [
          IconButton(
            tooltip: themeController.isDark
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            icon: Icon(
              themeController.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_outlined,
            ),
            onPressed: themeController.toggle,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ---- Success Banner & Message ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onPrimary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 48,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Order Confirmed!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Thank you for your purchase from SoleMate. Your order #SM-${(100000 + (widget.hashCode % 899999)).abs()} has been placed successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---- Order Summary Title ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Order Summary ($_checkoutItemCount items)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---- Cart Items List with Subtotal per Item ----
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _checkoutItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.12),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Small image thumbnail
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ProductImage(
                            path: item.product.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Item details & subtotal per item
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.product.formattedPrice} × ${item.quantity}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item.formattedSubtotal,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: _checkoutItems.length,
              ),
            ),
          ),

          // ---- Price Breakdown & Final Total ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.15),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Items Subtotal',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          '₱${_withThousandsSeparator(_checkoutTotal)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shipping',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'FREE',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '₱${_withThousandsSeparator(_checkoutTotal)}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---- Done / Return to Shop Button ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    cartController.clearCart();
                    context.go('/');
                  },
                  icon: const Icon(Icons.storefront_rounded),
                  label: const Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
