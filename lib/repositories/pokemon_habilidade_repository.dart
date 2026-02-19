import 'package:sqflite/sqflite.dart';

class PokemonHabilidadeRepository {
  final Database db;
  PokemonHabilidadeRepository({required this.db});

  Future<void> insert(
    int pokemonId,
    int habilidadeId,
    bool isHidden,
    int slot,
  ) async {
    await db.insert('pokemon_habilidade', {
      'pokemon_id': pokemonId,
      'habilidade_id': habilidadeId,
      'is_hidden': isHidden ? 1 : 0,
      'slot': slot,
    });
  }
}
