import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/nickname_editor.dart';
import '../widgets/favorites_panel.dart';

class PokemonDetailScreen extends ConsumerStatefulWidget {
  const PokemonDetailScreen({super.key});

  @override
  ConsumerState<PokemonDetailScreen> createState() =>
      _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends ConsumerState<PokemonDetailScreen> {
  bool _showFavorites = false;

  static const Map<String, List<Color>> _typeGradients = {
    'normal': [Color(0xFFA8A77A), Color(0xFFCFCDA8)],
    'fire': [Color(0xFFEE8130), Color(0xFFF5AC78)],
    'water': [Color(0xFF6390F0), Color(0xFF9DB7F5)],
    'electric': [Color(0xFFF7D02C), Color(0xFFFAE078)],
    'grass': [Color(0xFF7AC74C), Color(0xFFA7DB8D)],
    'ice': [Color(0xFF96D9D6), Color(0xFFBCE6E6)],
    'fighting': [Color(0xFFC22E28), Color(0xFFD67873)],
    'poison': [Color(0xFFA33EA1), Color(0xFFC183C1)],
    'ground': [Color(0xFFE2BF65), Color(0xFFEBD69D)],
    'flying': [Color(0xFFA98FF3), Color(0xFFC6B7F5)],
    'psychic': [Color(0xFFF95587), Color(0xFFFA92B2)],
    'bug': [Color(0xFFA6B91A), Color(0xFFC6D16E)],
    'rock': [Color(0xFFB6A136), Color(0xFFD1C17D)],
    'ghost': [Color(0xFF735797), Color(0xFFA292BC)],
    'dragon': [Color(0xFF6F35FC), Color(0xFFA27DFA)],
    'dark': [Color(0xFF705746), Color(0xFFA29288)],
    'steel': [Color(0xFFB7B7CE), Color(0xFFD1D1E0)],
    'fairy': [Color(0xFFD685AD), Color(0xFFF4BDC9)],
  };

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pokemonProvider);
    final pokemon = state.selectedPokemon;

    if (pokemon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pokémon Details')),
        body: const Center(child: Text('No Pokémon selected.')),
      );
    }

    final notifier = ref.read(pokemonProvider.notifier);
    final isFavorite = state.isFavorite(pokemon.id);
    final nickname = state.nickname(pokemon.id);
    final primaryType = pokemon.primaryType;
    final typeColors = _typeGradients[primaryType] ?? _typeGradients['normal']!;
    final formattedId = '#${pokemon.id.toString().padLeft(3, '0')}';
    final favoriteCount = state.favoritePokemon.length;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  typeColors[0].withValues(alpha: 0.94),
                  typeColors[1].withValues(alpha: 0.92),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ── Top bar ──────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                    child: Row(
                      children: [
                        // Back button
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.2),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Spacer(),
                        // ── Favourites toggle ────────────────────────────
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              tooltip: 'Favourites',
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.2),
                                foregroundColor: Colors.white,
                              ),
                              icon: Icon(
                                _showFavorites
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              onPressed: () =>
                                  setState(() => _showFavorites = true),
                            ),
                            if (favoriteCount > 0)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF4C6A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$favoriteCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        // ID badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            formattedId,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ── Pokémon image ─────────────────────────────────────────
                  Hero(
                    tag: 'pokemon-image-${pokemon.id}',
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Image.network(
                        pokemon.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.catching_pokemon,
                            size: 100,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Info panel ────────────────────────────────────────────
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFF),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(34)),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Nickname (if set) ───────────────────────
                            if (nickname != null) ...[
                              Text(
                                '"$nickname"',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: typeColors[0],
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                            // ── Original name ───────────────────────────
                            Text(
                              _capitalize(pokemon.name),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF273043),
                                    fontSize: nickname != null ? 18 : null,
                                  ),
                            ),
                            const SizedBox(height: 14),

                            // ── Type chips ──────────────────────────────
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: pokemon.types
                                  .map(
                                    (type) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: typeColors[0]
                                            .withValues(alpha: 0.18),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        border: Border.all(
                                          color: typeColors[0]
                                              .withValues(alpha: 0.45),
                                        ),
                                      ),
                                      child: Text(
                                        _capitalize(type),
                                        style: TextStyle(
                                          color: typeColors[0],
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 22),

                            // ── Action buttons ──────────────────────────
                            Row(
                              children: [
                                // Favourite toggle
                                Expanded(
                                  child: _ActionButton(
                                    icon: isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    label: isFavorite
                                        ? 'Unfavourite'
                                        : 'Favourite',
                                    color: const Color(0xFFFF4C6A),
                                    onTap: () =>
                                        notifier.toggleFavorite(pokemon.id),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Nickname editor
                                Expanded(
                                  child: _ActionButton(
                                    icon: Icons.edit_outlined,
                                    label: nickname != null
                                        ? 'Edit Nickname'
                                        : 'Add Nickname',
                                    color: const Color(0xFF5C6BC0),
                                    onTap: () => showNicknameEditor(
                                        context, pokemon),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),

                            // ── Info card ───────────────────────────────
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x16000000),
                                    blurRadius: 20,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pokémon ID',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    formattedId,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF273043),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Favorites panel overlay ────────────────────────────────────
          if (_showFavorites)
            FavoritesPanel(
              onClose: () => setState(() => _showFavorites = false),
            ),
        ],
      ),
    );
  }
}

// ── Small helper widget ────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
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
      ),
    );
  }
}
