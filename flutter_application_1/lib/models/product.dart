/// Simple immutable data model for a shop product.
///
/// This is a plain Dart class (not a widget), so it has nothing to do with
/// Stateless vs Stateful — it's just the data that our Stateless
/// [ProductCard] and product detail screen will render.
class Product {
  final String id;
  final String brand;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;

  const Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  String get formattedPrice => '₱${_withThousandsSeparator(price)}';

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
