import 'package:flutter/material.dart';

/// Placeholder Product Detail screen for the Sept 3 checkpoint.
///
/// The requirement at this stage is only that routing *reaches* an empty
/// details page — the real image/price/description layout and the
/// "Add to Cart" button get built in the next milestone. It's Stateless
/// for now since it displays nothing dynamic yet; once "Add to Cart"
/// needs to show pressed/added feedback, that button (not this whole
/// screen) is the piece that would become Stateful.
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Details for product "$productId" coming soon.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
