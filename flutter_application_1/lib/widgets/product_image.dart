import 'package:flutter/material.dart';

/// Renders a product image from either a bundled asset (e.g.
/// `assets/products/aj1_chicago.jpg`) or a network URL — whichever
/// [path] looks like — so [Product.imageUrl] can hold either kind of
/// value without the rest of the app needing to care which one it is.
///
/// Once you provide real photos, put them in `assets/products/` and
/// point each product's `imageUrl` at `assets/products/<filename>`.
class ProductImage extends StatelessWidget {
  final String path;
  final BoxFit fit;

  const ProductImage({super.key, required this.path, this.fit = BoxFit.cover});

  bool get _isNetwork => path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    Widget errorFallback() => Icon(
          Icons.image_not_supported_outlined,
          color: primary,
        );

    if (_isNetwork) {
      return Image.network(
        path,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => errorFallback(),
      );
    }

    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => errorFallback(),
    );
  }
}
