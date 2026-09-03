import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String path;
  final BoxFit fit;

  const ProductImage({super.key, required this.path, this.fit = BoxFit.cover});


  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    Widget errorFallback() => Icon(
          Icons.image_not_supported_outlined,
          color: primary,
        );

    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => errorFallback(),
    );
  }
}
