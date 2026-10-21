import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

// ---------------------------------------------------------------------------
// State model
// ---------------------------------------------------------------------------

class PokemonState {
  final List<Pokemon> allPokemon;
  final bool isLoading;
  final String? errorMessage;
  final Set<int> favoriteIds;
  final Map<int, String> nicknames;
  final String? selectedType;
  final int? selectedPokemonId;

  const PokemonState({
    this.allPokemon = const [],
    this.isLoading = false,
    this.errorMessage,
    this.favoriteIds = const {},
    this.nicknames = const {},
    this.selectedType,
    this.selectedPokemonId,
  });

  /// Pokémon list filtered by the active type (if any).
  List<Pokemon> get pokemon {
    if (selectedType == null) return allPokemon;
    return allPokemon
        .where((p) => p.types.contains(selectedType))
        .toList();
  }

  /// Only the Pokémon the user has marked as favourites.
  List<Pokemon> get favoritePokemon =>
      allPokemon.where((p) => favoriteIds.contains(p.id)).toList();

  bool isFavorite(int id) => favoriteIds.contains(id);

  String? nickname(int id) => nicknames[id];

  Pokemon? get selectedPokemon {
    if (selectedPokemonId == null) return null;
    for (final p in allPokemon) {
      if (p.id == selectedPokemonId) return p;
    }
    return null;
  }

  PokemonState copyWith({
    List<Pokemon>? allPokemon,
    bool? isLoading,
    String? errorMessage,
    Set<int>? favoriteIds,
    Map<int, String>? nicknames,
    Object? selectedType = _sentinel,
    int? selectedPokemonId,
    bool clearSelectedPokemon = false,
    bool clearError = false,
  }) {
    return PokemonState(
      allPokemon: allPokemon ?? this.allPokemon,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      favoriteIds: favoriteIds ?? this.favoriteIds,
      nicknames: nicknames ?? this.nicknames,
      selectedType:
          identical(selectedType, _sentinel) ? this.selectedType : selectedType as String?,
      selectedPokemonId:
          clearSelectedPokemon ? null : (selectedPokemonId ?? this.selectedPokemonId),
    );
  }
}

const _sentinel = Object();

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class PokemonNotifier extends StateNotifier<PokemonState> {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';
  static const int _limit = 30;

  PokemonNotifier() : super(const PokemonState());

  // ── List management ─────────────────────────────────────────────────────

  Future<void> fetchPokemon() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response =
          await http.get(Uri.parse('$_baseUrl?limit=$_limit'));
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load Pokémon. Status code: ${response.statusCode}');
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

      state = state.copyWith(
        allPokemon: fetchedPokemon,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
        allPokemon: const [],
      );
    }
  }

  // ── Selection ───────────────────────────────────────────────────────────

  void selectPokemon(int id) {
    state = state.copyWith(selectedPokemonId: id);
  }

  // ── Favourites ──────────────────────────────────────────────────────────

  void toggleFavorite(int id) {
    final updated = Set<int>.from(state.favoriteIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = state.copyWith(favoriteIds: updated);
  }

  // ── Nicknames ───────────────────────────────────────────────────────────

  void setNickname(int id, String nickname) {
    final trimmed = nickname.trim();
    final updated = Map<int, String>.from(state.nicknames);
    if (trimmed.isEmpty) {
      updated.remove(id);
    } else {
      updated[id] = trimmed;
    }
    state = state.copyWith(nicknames: updated);
  }

  void removeNickname(int id) {
    final updated = Map<int, String>.from(state.nicknames);
    updated.remove(id);
    state = state.copyWith(nicknames: updated);
  }

  // ── Type filter ─────────────────────────────────────────────────────────

  void setTypeFilter(String? type) {
    state = state.copyWith(selectedType: type);
  }

  void clearTypeFilter() {
    state = state.copyWith(selectedType: null);
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------

final pokemonProvider =
    StateNotifierProvider<PokemonNotifier, PokemonState>((ref) {
  return PokemonNotifier()..fetchPokemon();
});
