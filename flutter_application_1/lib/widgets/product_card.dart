import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_image.dart';

/// Displays a single product's image, brand, name, and price.
///
/// This is a [StatelessWidget] on purpose: once given a [Product], nothing
/// about this card ever changes on its own — there's no internal state to
/// track (no counter, no toggle, no animation driven by user interaction
/// inside the card itself). Tapping it only triggers navigation, which is
/// handled by the parent via [onTap]; the card doesn't manage that
/// transition itself. If this card later grew its own "wishlist heart"
/// toggle, that specific piece would need to become Stateful — but the
/// static display shell here should stay Stateless.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Improved image area with overlays (favorite button + price chip)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // subtle brand-tinted backdrop
                  Container(
                    color: primary.withOpacity(
                        theme.brightness == Brightness.dark ? 0.18 : 0.06),
                  ),

                  // padded product photo with soft rounded corner
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ProductImage(
                        path: product.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // price chip overlay (bottom-left)
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        product.formattedPrice,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product meta: brand, name
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: primary,
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(height: 1.12),
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
