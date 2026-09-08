import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/cart_scope.dart';
import '../models/cart_item.dart';
import '../theme/theme_scope.dart';
import '../widgets/product_image.dart';

/// The Cart screen showing all added items, stateful quantity controls (+ / -),
/// live running total updates, and a CTA to proceed to checkout.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = ThemeScope.of(context);
    final cartController = CartScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('My Cart'),
            if (!cartController.isEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cartController.totalItemCount} items',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
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
          if (!cartController.isEmpty)
            IconButton(
              tooltip: 'Clear Cart',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Cart?'),
                    content: const Text(
                      'Are you sure you want to remove all items from your cart?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartController.clearCart();
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          'Clear',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: cartController.isEmpty
          ? _EmptyCartView()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: cartController.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cartController.items[index];
                      return _CartItemTile(item: item);
                    },
                  ),
                ),

                // Live Total & Proceed to Checkout Bottom Container
                _CartSummaryBottomBar(),
              ],
            ),
    );
  }
}

/// Widget displaying a clean empty state when cart has no items.
class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore our catalog of authentic sneakers and add your favorite pairs.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Browse Sneakers'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Item tile representing a product in the cart with stateful quantity controls (+ / -).
class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartController = CartScope.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Thumbnail image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(
                  theme.brightness == Brightness.dark ? 0.18 : 0.06,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: ProductImage(
                path: item.product.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 14),

            // Name, Unit price, Subtotal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.brand.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.product.formattedPrice,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.formattedSubtotal,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Quantity Controls Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stateful (+ / -) controls
                      Container(
                        height: 34,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32),
                              icon: const Icon(Icons.remove_rounded, size: 18),
                              onPressed: () {
                                cartController.decrementQuantity(item.product.id);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${item.quantity}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              onPressed: () {
                                cartController.incrementQuantity(item.product.id);
                              },
                            ),
                          ],
                        ),
                      ),

                      // Delete button
                      IconButton(
                        tooltip: 'Remove item',
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: theme.colorScheme.error.withOpacity(0.8),
                        ),
                        onPressed: () {
                          cartController.removeFromCart(item.product.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom persistent bar for live totals and Proceed to Checkout CTA.
class _CartSummaryBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartController = CartScope.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Running Total',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  cartController.formattedTotalPrice,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: cartController.isEmpty
                    ? null
                    : () => context.push('/checkout'),
                icon: const Icon(Icons.payment_rounded),
                label: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
