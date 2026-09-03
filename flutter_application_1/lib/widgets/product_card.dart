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
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image sits on a soft brand-tinted backdrop rather than a
            // bare white/black square — gives the grid a cohesive,
            // "in-store" feel instead of looking like scattered stock
            // photos.
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: primary.withOpacity(theme.brightness == Brightness.dark ? 0.16 : 0.07),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ProductImage(path: product.imageUrl),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
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
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(height: 1.15),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'FROM',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        product.formattedPrice,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
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
