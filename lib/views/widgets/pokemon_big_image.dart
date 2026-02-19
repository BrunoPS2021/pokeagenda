import 'package:flutter/material.dart';
import '../../models/pokemon.dart';

class PokemonBigImage extends StatelessWidget {
  final Pokemon? pokemon;

  const PokemonBigImage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    if (pokemon == null) {
      return const Center(child: Text("Selecione um Pokémon"));
    }

    final url =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon!.id}.png";

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),

      child: Image.network(
        url,
        key: ValueKey(pokemon!.id),
        height: 320,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported, size: 120),
      ),
    );
  }
}
