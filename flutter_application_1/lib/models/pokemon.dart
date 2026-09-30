class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extract ID from URL (e.g., "https://pokeapi.co/api/v2/pokemon/1/") if available, or parse id field
    int pokemonId = json['id'] ?? 0;
    if (pokemonId == 0 && json.containsKey('url')) {
      final String url = json['url'];
      final uriParts = url.split('/').where((part) => part.isNotEmpty).toList();
      pokemonId = int.tryParse(uriParts.last) ?? 0;
    }

    // Official artwork image URL from raw GitHub assets or PokeAPI sprite structure
    final String image = json['sprites']?['other']?['official-artwork']?['front_default'] ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';

    return Pokemon(
      id: pokemonId,
      name: json['name'] ?? 'Unknown',
      imageUrl: image,
    );
  }
}
