import 'product.dart';

/// Data model representing a product added to the shopping cart, along with
/// its current quantity.
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Subtotal for this specific cart item line (unit price * quantity).
  double get subtotal => product.price * quantity;

  /// Formatted subtotal string with currency symbol and thousands separator.
  String get formattedSubtotal => '₱${_withThousandsSeparator(subtotal)}';

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
