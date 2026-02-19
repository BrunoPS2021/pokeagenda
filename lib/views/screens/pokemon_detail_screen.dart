import 'package:flutter/material.dart';
import '../../models/pokemon.dart';
import '../../repositories/pokemon_repository.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final repo = PokemonRepository();
  late Pokemon p;

  @override
  void initState() {
    super.initState();
    p = widget.pokemon;
  }

  String url() =>
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${p.id}.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(p.name.toUpperCase()),
        actions: [
          IconButton(
            icon: Icon(
              p.favorito ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
            onPressed: () async {
              p.favorito = !p.favorito;

              await repo.toggleFavorito(p.id, p.favorito);

              setState(() {});
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Hero(tag: "poke_${p.id}", child: Image.network(url(), height: 260)),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    linha("ID", p.id.toString()),
                    linha("HEIGHT", p.height.toString()),
                    linha("WEIGHT", p.weight.toString()),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            barra("HP", p.id % 120),
            barra("ATK", (p.id * 2) % 120),
            barra("DEF", (p.id * 3) % 120),
            barra("SPD", (p.id * 4) % 120),
          ],
        ),
      ),
    );
  }

  Widget linha(String a, String b) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(a), Text(b)],
    );
  }

  Widget barra(String nome, int v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nome),

          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: v / 120),
            duration: const Duration(milliseconds: 700),

            builder: (c, val, _) => LinearProgressIndicator(value: val),
          ),
        ],
      ),
    );
  }
}
