import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

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
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;
    final formattedId = '#${pokemon.id.toString().padLeft(3, '0')}';
    final capitalizedName = pokemon.name.isEmpty
        ? 'Unknown'
        : widget._capitalize(pokemon.name);
    final primaryType = pokemon.primaryType;
    final typeColors =
        PokemonCard._typeGradients[primaryType] ??
        PokemonCard._typeGradients['normal']!;
    final visibleTypes = pokemon.types.take(2).toList();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        scale: _isHovered ? 1.035 : 1.0,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          offset: _isHovered ? const Offset(0, -0.04) : Offset.zero,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: typeColors[0].withValues(
                    alpha: _isHovered ? 0.45 : 0.35,
                  ),
                  blurRadius: _isHovered ? 20 : 12,
                  offset: Offset(0, _isHovered ? 12 : 7),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          typeColors[0].withValues(alpha: 0.85),
                          typeColors[1],
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -22,
                    right: -22,
                    child: Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -28,
                    left: -14,
                    child: Icon(
                      Icons.catching_pokemon,
                      size: 70,
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.05),
                            Colors.black.withValues(alpha: 0.28),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.26),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              formattedId,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Image.network(
                            pokemon.imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.catching_pokemon,
                                size: 40,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          capitalizedName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 4,
                          runSpacing: 4,
                          children: visibleTypes
                              .map(
                                (type) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Text(
                                    widget._capitalize(type),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9.5,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
