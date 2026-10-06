import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pokemon_provider.dart';
import 'screens/pokemon_grid_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PokemonProvider()..fetchPokemon(),
      child: MaterialApp(
        title: 'Pokédex App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF7F9FC),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        home: const PokemonGridScreen(),
      ),
    );
  }
}
