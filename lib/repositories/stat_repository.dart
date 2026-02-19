import '../database/db_helper.dart';

class StatRepository {
  /// INSERE STAT OU RETORNA ID
  Future<int> insertStat(String name) async {
    final db = await DBHelper.database;

    final existing = await db.query(
      'stat',
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      return existing.first['id'] as int;
    }

    return await db.insert('stat', {'name': name});
  }

  /// RELAÇÃO POKEMON_STAT
  Future<void> insertPokemonStat(
    int pokemonId,
    int statId,
    int baseStat,
    int effort,
  ) async {
    final db = await DBHelper.database;

    await db.insert('pokemon_stat', {
      'pokemon_id': pokemonId,
      'stat_id': statId,
      'base_stat': baseStat,
      'effort': effort,
    });
  }

  /// ⭐ GET STATS DO POKEMON (CORRIGIDO)
  Future<List<String>> getStatsDoPokemon(int pokemonId) async {
    final db = await DBHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT s.name || ' ' || ps.base_stat as txt
      FROM stat s
      JOIN pokemon_stat ps ON ps.stat_id = s.id
      WHERE ps.pokemon_id = ?
    ''',
      [pokemonId],
    );

    return result.map((e) => e['txt'] as String).toList();
  }
}
