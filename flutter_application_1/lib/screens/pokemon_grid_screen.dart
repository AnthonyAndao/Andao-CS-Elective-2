import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/poke_service.dart';
import '../widgets/pokemon_card.dart';

class PokemonGridScreen extends StatefulWidget {
  const PokemonGridScreen({super.key});

  @override
  State<PokemonGridScreen> createState() => _PokemonGridScreenState();
}

class _PokemonGridScreenState extends State<PokemonGridScreen> {
  final PokeService _pokeService = PokeService();
  late Future<List<Pokemon>> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _loadPokemon();
  }

  void _loadPokemon() {
    setState(() {
      _pokemonFuture = _pokeService.fetch30Pokemon();
    });
  }

  Future<void> _refreshPokemon() async {
    _loadPokemon();
    await _pokemonFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.catching_pokemon, color: Colors.white),
            SizedBox(width: 8),
            Text('Pokédex'),
          ],
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFD81B60)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9FBFF), Color(0xFFF2F5FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Pokemon>>(
          future: _pokemonFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.redAccent),
                    SizedBox(height: 16),
                    Text(
                      'Catching Pokémon...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to fetch Pokémon',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _loadPokemon,
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

            final pokemonList = snapshot.data;
            if (pokemonList == null || pokemonList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No Pokémon found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadPokemon,
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshPokemon,
              color: Colors.redAccent,
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.58,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: pokemonList.length,
                itemBuilder: (context, index) {
                  return PokemonCard(pokemon: pokemonList[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
