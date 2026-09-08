import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/cart_scope.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../theme/theme_scope.dart';
import '../widgets/product_image.dart';

/// Full Product Detail screen for SoleMate e-commerce application.
///
/// Demonstrates:
/// - Navigation 2.0 (`go_router`) parameter routing.
/// - Displaying product image, brand, price, category, and description cleanly.
/// - Stateful widgets for quantity selection and Add-to-Cart interactions.
/// - Theme toggle and live cart badge in the AppBar.
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _increment() {
    setState(() => _quantity++);
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = ThemeScope.of(context);
    final cartController = CartScope.of(context);

    // Look up product from catalog
    final product = products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => Product(
        id: widget.productId,
        brand: 'SoleMate',
        name: 'Product Not Found',
        category: 'Lifestyle',
        price: 0,
        imageUrl: '',
        description: 'The requested product could not be located in our catalog.',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
          // Shopping bag icon with live item count badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: 'Cart',
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => context.push('/cart'),
              ),
              if (cartController.totalItemCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${cartController.totalItemCount}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Product Hero Image Container ----
            Container(
              height: 320,
              width: double.infinity,
              color: theme.colorScheme.primary.withOpacity(
                theme.brightness == Brightness.dark ? 0.15 : 0.05,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ProductImage(
                        path: product.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified Authentic',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---- Product Details Section ----
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand & Category Chips
                  Row(
                    children: [
                      Chip(
                        label: Text(product.brand.toUpperCase()),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        side: BorderSide.none,
                        label: Text(
                          product.category,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Product Title
                  Text(
                    product.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Product Price
                  Text(
                    product.formattedPrice,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // Description Title & Text
                  Text(
                    'About this sneaker',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ---- Quantity Selection (Stateful Control) ----
                  Text(
                    'Quantity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_rounded),
                              onPressed: _quantity > 1 ? _decrement : null,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                '$_quantity',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_rounded),
                              onPressed: _increment,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Total: ₱${_withThousandsSeparator(product.price * _quantity)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ---- Add to Cart CTA Button ----
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        cartController.addToCart(product, quantity: _quantity);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            content: Text(
                              'Added $_quantity x ${product.name} to your cart!',
                            ),
                            action: SnackBarAction(
                              label: 'VIEW CART',
                              onPressed: () => context.push('/cart'),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart_rounded),
                      label: Text(
                        'Add $_quantity to Cart',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}
