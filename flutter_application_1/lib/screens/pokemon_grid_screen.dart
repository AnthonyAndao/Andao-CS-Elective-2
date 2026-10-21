import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/type_filter_bar.dart';
import '../widgets/favorites_panel.dart';
import 'pokemon_detail_screen.dart';

class PokemonGridScreen extends ConsumerStatefulWidget {
  const PokemonGridScreen({super.key});

  @override
  ConsumerState<PokemonGridScreen> createState() => _PokemonGridScreenState();
}

class _PokemonGridScreenState extends ConsumerState<PokemonGridScreen> {
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pokemonProvider);
    final notifier = ref.read(pokemonProvider.notifier);
    final favoriteCount = state.favoritePokemon.length;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // ── Main content column ─────────────────────────────────────────
          Column(
            children: [
              // ── Gradient header ─────────────────────────────────────────
              Container(
                padding: EdgeInsets.fromLTRB(16, topPadding + 12, 12, 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFFD81B60)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    // Title
                    const Icon(Icons.catching_pokemon,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Pokédex',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Spacer(),
                    // ── Favourites pill button ─────────────────────────────
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _PillButton(
                          icon: favoriteCount > 0
                              ? Icons.favorite
                              : Icons.favorite_border,
                          label: 'Favorites',
                          onTap: () =>
                              setState(() => _showFavorites = true),
                          iconColor: favoriteCount > 0
                              ? const Color(0xFFE53935)
                              : const Color(0xFFE53935),
                        ),
                        if (favoriteCount > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF4C6A),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  '$favoriteCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),

              // ── Type filter bar ──────────────────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const TypeFilterBar(),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              // ── Grid / states ────────────────────────────────────────────
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF9FBFF), Color(0xFFF2F5FA)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: _buildBody(state, notifier),
                ),
              ),
            ],
          ),

          // ── Favorites panel overlay ─────────────────────────────────────
          if (_showFavorites)
            FavoritesPanel(
              onClose: () => setState(() => _showFavorites = false),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(PokemonState state, PokemonNotifier notifier) {
    // Loading
    if (state.isLoading && state.allPokemon.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.redAccent),
            SizedBox(height: 16),
            Text(
              'Catching Pokémon…',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Error
    if (state.errorMessage != null && state.allPokemon.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 60, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                'Failed to fetch Pokémon',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: notifier.fetchPokemon,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final displayList = state.pokemon;

    // Empty / no filter results
    if (displayList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              state.selectedType != null
                  ? 'No ${state.selectedType} Pokémon found.'
                  : 'No Pokémon found.',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            if (state.selectedType != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: notifier.clearTypeFilter,
                child: const Text('Clear Filter'),
              ),
            ],
          ],
        ),
      );
    }

    // Grid
    return RefreshIndicator(
      onRefresh: notifier.fetchPokemon,
      color: Colors.redAccent,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.55,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          final pokemon = displayList[index];
          return PokemonCard(
            pokemon: pokemon,
            onTap: () {
              ref.read(pokemonProvider.notifier).selectPokemon(pokemon.id);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PokemonDetailScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ── Reusable pill action button ─────────────────────────────────────────────

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? const Color(0xFFE53935);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
