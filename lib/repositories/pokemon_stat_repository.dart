import 'package:sqflite/sqflite.dart';

class PokemonStatRepository {
  final Database db;
  PokemonStatRepository({required this.db});

  Future<void> insert(
    int pokemonId,
    int statId,
    int baseStat,
    int effort,
  ) async {
    await db.insert('pokemon_stat', {
      'pokemon_id': pokemonId,
      'stat_id': statId,
      'base_stat': baseStat,
      'effort': effort,
    });
  }
}
