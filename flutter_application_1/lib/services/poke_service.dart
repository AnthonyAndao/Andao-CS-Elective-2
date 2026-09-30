import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  /// Fetches 30 Pokémon from PokéAPI.
  /// 
  /// Why Future instead of Stream?
  /// A `Future` is ideal here because fetching a fixed batch of 30 items is a 
  /// single, one-time asynchronous HTTP request-response operation.
  /// Streams are better suited for continuous or multi-event data flow (e.g. WebSockets, real-time updates).
  Future<List<Pokemon>> fetch30Pokemon() async {
    final response = await http.get(Uri.parse('$baseUrl?limit=30'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'] ?? [];

      List<Pokemon> pokemonList = [];
      for (var item in results) {
        pokemonList.add(Pokemon.fromJson(item));
      }

      return pokemonList;
    } else {
      throw Exception('Failed to load Pokémon. Status code: ${response.statusCode}');
    }
  }
}
