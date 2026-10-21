import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';

/// Shows the nickname editor as a modal bottom sheet.
/// Returns when the user dismisses the sheet.
Future<void> showNicknameEditor(
  BuildContext context,
  Pokemon pokemon,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _NicknameEditorSheet(pokemon: pokemon),
  );
}

class _NicknameEditorSheet extends ConsumerStatefulWidget {
  final Pokemon pokemon;
  const _NicknameEditorSheet({required this.pokemon});

  @override
  ConsumerState<_NicknameEditorSheet> createState() =>
      _NicknameEditorSheetState();
}

class _NicknameEditorSheetState extends ConsumerState<_NicknameEditorSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Pre-fill with any existing nickname
    final existing = ref.read(pokemonProvider).nickname(widget.pokemon.id);
    _controller = TextEditingController(text: existing ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    ref
        .read(pokemonProvider.notifier)
        .setNickname(widget.pokemon.id, _controller.text);
    Navigator.of(context).pop();
  }

  void _remove() {
    ref.read(pokemonProvider.notifier).removeNickname(widget.pokemon.id);
    Navigator.of(context).pop();
  }

  String _capitalize(String v) =>
      v.isEmpty ? v : v[0].toUpperCase() + v.substring(1);

  @override
  Widget build(BuildContext context) {
    final hasNickname =
        ref.watch(pokemonProvider.select((s) => s.nickname(widget.pokemon.id))) !=
            null;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Text(
            'Nickname Editor',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'For ${_capitalize(widget.pokemon.name)}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: 30,
            decoration: InputDecoration(
              hintText: 'Enter a nickname…',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () => _controller.clear(),
              ),
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          // Action row
          Row(
            children: [
              if (hasNickname) ...[
                OutlinedButton.icon(
                  onPressed: _remove,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Remove'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Save Nickname',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
