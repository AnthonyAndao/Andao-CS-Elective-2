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

      return Future.wait(
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

          final detailData = json.decode(detailResponse.body) as Map<String, dynamic>;
          return Pokemon.fromJson(detailData);
        }),
      );
    } else {
      throw Exception('Failed to load Pokémon. Status code: ${response.statusCode}');
    }
  }
}
