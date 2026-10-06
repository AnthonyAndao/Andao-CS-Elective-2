import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonProvider extends ChangeNotifier {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';
  static const int _limit = 30;

  List<Pokemon> _pokemon = const [];
  bool _isLoading = false;
  String? _errorMessage;
  int? _selectedPokemonId;

  List<Pokemon> get pokemon => _pokemon;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Pokemon? get selectedPokemon => getPokemonById(_selectedPokemonId);

  Pokemon? getPokemonById(int? id) {
    if (id == null) return null;
    for (final entry in _pokemon) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }

  void selectPokemon(int id) {
    _selectedPokemonId = id;
    notifyListeners();
  }

  Future<void> fetchPokemon() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl?limit=$_limit'));
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load Pokémon. Status code: ${response.statusCode}',
        );
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final List results = data['results'] as List? ?? [];
      final fetchedPokemon = await Future.wait(
        results.map((item) async {
          final detailUrl = item['url']?.toString();
          if (detailUrl == null || detailUrl.isEmpty) {
            throw Exception('Pokémon detail URL is missing.');
          }

          final detailResponse = await http.get(Uri.parse(detailUrl));
          if (detailResponse.statusCode != 200) {
            throw Exception(
              'Failed to load details for ${item['name'] ?? 'unknown Pokémon'}. '
              'Status code: ${detailResponse.statusCode}',
            );
          }

          final detailData =
              json.decode(detailResponse.body) as Map<String, dynamic>;
          return Pokemon.fromJson(detailData);
        }),
      );

      _pokemon = fetchedPokemon;
      if (_selectedPokemonId != null && selectedPokemon == null) {
        _selectedPokemonId = null;
      }
    } catch (error) {
      _errorMessage = error.toString();
      _pokemon = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
