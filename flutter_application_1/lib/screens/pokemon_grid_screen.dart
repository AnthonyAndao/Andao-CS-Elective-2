import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class PokemonGridScreen extends StatelessWidget {
  const PokemonGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

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
        child: Builder(
          builder: (context) {
            if (provider.isLoading && provider.pokemon.isEmpty) {
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

            if (provider.errorMessage != null && provider.pokemon.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to fetch Pokémon',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: provider.fetchPokemon,
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

            if (provider.pokemon.isEmpty) {
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
                      onPressed: provider.fetchPokemon,
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: provider.fetchPokemon,
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
                itemCount: provider.pokemon.length,
                itemBuilder: (context, index) {
                  final pokemon = provider.pokemon[index];
                  return PokemonCard(
                    pokemon: pokemon,
                    onTap: () {
                      context.read<PokemonProvider>().selectPokemon(pokemon.id);
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
          },
        ),
      ),
    );
  }
}
