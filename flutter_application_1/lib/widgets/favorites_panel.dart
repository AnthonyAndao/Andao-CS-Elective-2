import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';

/// A retractable slide-up panel that shows the user's favourite Pokémon.
/// It is meant to be placed inside a [Stack] that covers the entire screen,
/// so it can slide up from the bottom over the main content.
class FavoritesPanel extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const FavoritesPanel({super.key, required this.onClose});

  @override
  ConsumerState<FavoritesPanel> createState() => _FavoritesPanelState();
}

class _FavoritesPanelState extends ConsumerState<FavoritesPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pokemonProvider);
    final favorites = state.favoritePokemon;

    return GestureDetector(
      onTap: _close,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: Colors.black54,
          child: GestureDetector(
            onTap: () {}, // Prevent taps propagating through panel content
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.55,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFF),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 30,
                        offset: Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle bar
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 4),
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      // Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 8, 10),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite,
                                color: Color(0xFFE53935), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Favourites',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: _close,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Content
                      if (favorites.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 36),
                          child: Column(
                            children: [
                              Icon(Icons.favorite_border,
                                  size: 48, color: Colors.grey),
                              SizedBox(height: 12),
                              Text(
                                'No favourite Pokémon yet.',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tap ♥ on any card to add one!',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      else
                        Flexible(
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                            shrinkWrap: true,
                            itemCount: favorites.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              return _FavoriteTile(pokemon: favorites[index]);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteTile extends ConsumerWidget {
  final Pokemon pokemon;
  const _FavoriteTile({required this.pokemon});

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
    final state = ref.watch(pokemonProvider);
    final notifier = ref.read(pokemonProvider.notifier);
    final nickname = state.nickname(pokemon.id);
    final typeColor =
        _typeColors[pokemon.primaryType] ?? const Color(0xFFA8A77A);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 48,
            height: 48,
            color: typeColor.withValues(alpha: 0.15),
            child: Image.network(
              pokemon.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.catching_pokemon,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        title: Text(
          nickname != null
              ? '"$nickname"'
              : _capitalize(pokemon.name),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: nickname != null ? const Color(0xFF5C6BC0) : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: nickname != null
            ? Text(
                _capitalize(pokemon.name),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Color(0xFFE53935)),
          onPressed: () => notifier.toggleFavorite(pokemon.id),
          tooltip: 'Remove from favourites',
        ),
      ),
    );
  }
}
