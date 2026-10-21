import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pokemon_provider.dart';

/// Horizontally scrollable chip row that filters Pokémon by type.
class TypeFilterBar extends ConsumerWidget {
  const TypeFilterBar({super.key});

  static const List<String> _types = [
    'fire', 'water', 'grass', 'electric', 'psychic', 'ice',
    'dragon', 'dark', 'fairy', 'fighting', 'poison', 'ground',
    'rock', 'ghost', 'steel', 'bug', 'flying', 'normal',
  ];

  static const Map<String, Color> _typeColors = {
    'normal': Color(0xFFA8A77A),
    'fire': Color(0xFFEE8130),
    'water': Color(0xFF6390F0),
    'electric': Color(0xFFF7D02C),
    'grass': Color(0xFF7AC74C),
    'ice': Color(0xFF96D9D6),
    'fighting': Color(0xFFC22E28),
    'poison': Color(0xFFA33EA1),
    'ground': Color(0xFFE2BF65),
    'flying': Color(0xFFA98FF3),
    'psychic': Color(0xFFF95587),
    'bug': Color(0xFFA6B91A),
    'rock': Color(0xFFB6A136),
    'ghost': Color(0xFF735797),
    'dragon': Color(0xFF6F35FC),
    'dark': Color(0xFF705746),
    'steel': Color(0xFFB7B7CE),
    'fairy': Color(0xFFD685AD),
  };

  String _capitalize(String v) =>
      v.isEmpty ? v : v[0].toUpperCase() + v.substring(1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(pokemonProvider).selectedType;
    final notifier = ref.read(pokemonProvider.notifier);

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          // "All" chip — clears filter
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: const Text('All'),
              selected: selectedType == null,
              onSelected: (_) => notifier.clearTypeFilter(),
              selectedColor: const Color(0xFFE53935),
              labelStyle: TextStyle(
                color: selectedType == null ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(
                color: selectedType == null
                    ? Colors.transparent
                    : Colors.grey.shade300,
              ),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          // Type chips
          ..._types.map((type) {
            final isSelected = selectedType == type;
            final color = _typeColors[type] ?? const Color(0xFFA8A77A);
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                avatar: isSelected
                    ? null
                    : CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.2),
                        radius: 8,
                        child: Icon(Icons.circle, size: 8, color: color),
                      ),
                label: Text(_capitalize(type)),
                selected: isSelected,
                onSelected: (_) => notifier.setTypeFilter(isSelected ? null : type),
                selectedColor: color,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            );
          }),
        ],
      ),
    );
  }
}
