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
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final brand = brands[index];
          final isSelected = brand == selected;

          return ChoiceChip(
            label: Text(brand),
            selected: isSelected,
            onSelected: (_) => onSelected(brand),
            showCheckmark: false,
            backgroundColor: theme.chipTheme.backgroundColor,
            selectedColor: theme.colorScheme.primary,
            labelStyle: theme.chipTheme.labelStyle?.copyWith(
              color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          );
        },
      ),
    );
  }
}
