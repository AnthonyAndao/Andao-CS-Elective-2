import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({super.key});

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
    final provider = context.watch<PokemonProvider>();
    final pokemon = provider.selectedPokemon;

    if (pokemon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pokémon Details')),
        body: const Center(child: Text('No Pokémon selected.')),
      );
    }

    final primaryType = pokemon.primaryType;
    final typeColors =
        _typeGradients[primaryType] ?? _typeGradients['normal']!;
    final formattedId = '#${pokemon.id.toString().padLeft(3, '0')}';

    return Scaffold(
      body: Container(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
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
              Hero(
                tag: 'pokemon-image-${pokemon.id}',
                child: Container(
                  width: 250,
                  height: 250,
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
                        size: 120,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(34),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _capitalize(pokemon.name),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF273043),
                              ),
                        ),
                        const SizedBox(height: 14),
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
                                    color: typeColors[0].withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: typeColors[0].withValues(alpha: 0.45),
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
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                formattedId,
                                style: Theme.of(context).textTheme.headlineSmall
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
    );
  }
}
