class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  String get primaryType => types.isNotEmpty ? types.first : 'normal';

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extract ID from URL (e.g., "https://pokeapi.co/api/v2/pokemon/1/") if available, or parse id field
    int pokemonId = json['id'] ?? 0;
    if (pokemonId == 0 && json.containsKey('url')) {
      final String url = json['url'];
      final uriParts = url.split('/').where((part) => part.isNotEmpty).toList();
      pokemonId = int.tryParse(uriParts.last) ?? 0;
    }

    // Official artwork image URL from raw GitHub assets or PokeAPI sprite structure
    final String image =
        json['sprites']?['other']?['official-artwork']?['front_default'] ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';

    final List<dynamic> rawTypes = json['types'] ?? [];
    final List<Map<String, dynamic>> parsedTypes =
        rawTypes.whereType<Map<String, dynamic>>().toList()..sort(
          (a, b) =>
              ((a['slot'] as num?) ?? 99).compareTo((b['slot'] as num?) ?? 99),
        );
    final List<String> pokemonTypes = parsedTypes
        .map(
          (entry) =>
              (entry['type']?['name'] ?? 'normal').toString().toLowerCase(),
        )
        .toList();

    return Pokemon(
      id: pokemonId,
      name: json['name'] ?? 'Unknown',
      imageUrl: image,
      types: pokemonTypes,
    );
  }
}
