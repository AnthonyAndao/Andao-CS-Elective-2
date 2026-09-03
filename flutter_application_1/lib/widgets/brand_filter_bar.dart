import 'package:flutter/material.dart';

/// A horizontal row of selectable brand chips (All, Nike, Jordan, ...).
///
/// This widget itself is [StatelessWidget] — it doesn't own the selection.
/// It just renders whatever `selected` value it's given and reports taps
/// back via [onSelected]. The actual "which brand is selected" state lives
/// one level up, in [HomeScreen]'s State object, since that's the widget
/// that needs to react to it (by re-filtering the grid). Keeping this row
/// stateless keeps it simple and reusable.
class BrandFilterBar extends StatelessWidget {
  final List<String> brands;
  final String selected;
  final ValueChanged<String> onSelected;

  const BrandFilterBar({
    super.key,
    required this.brands,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final brand = brands[index];
          final isSelected = brand == selected;
          final isAll = brand.toLowerCase() == 'all';

          // entrance + subtle slide animation per item
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 420 + (index * 30)),
            curve: Curves.easeOut,
            builder: (context, t, child) {
              return Transform.translate(
                offset: Offset(0, (1 - t) * 6),
                child: AnimatedScale(
                  scale: isSelected ? 1.04 : 1.0,
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutBack,
                  child: child,
                ),
              );
            },
            child: Material(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceVariant.withOpacity(0.95),
              elevation: isSelected ? 2 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: isAll && !isSelected
                    ? BorderSide(color: theme.colorScheme.primary, width: 1.6)
                    : (!isSelected
                        ? BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.12))
                        : BorderSide.none),
              ),
              child: InkWell(
                onTap: () => onSelected(brand),
                borderRadius: BorderRadius.circular(10),
                splashFactory: InkRipple.splashFactory,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Center(
                    child: Text(
                      brand,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
