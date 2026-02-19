import 'package:flutter/material.dart';
import '../../models/pokemon.dart';

class PokemonTile extends StatelessWidget {
  final Pokemon pokemon;
  final bool selecionado;
  final VoidCallback onTap;

  const PokemonTile({
    super.key,
    required this.pokemon,
    required this.selecionado,
    required this.onTap,
  });

  String get image =>
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selecionado,
      leading: Image.network(image, width: 50),
      title: Text(pokemon.name.toUpperCase()),
      onTap: onTap,
    );
  }
}
