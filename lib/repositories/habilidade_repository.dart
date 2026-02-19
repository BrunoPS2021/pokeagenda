import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';

class HabilidadeRepository {
  /// INSERT
  Future<int> insertHabilidade(String name) async {
    final db = await DBHelper.database;

    final result = await db.query(
      'habilidade',
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }

    return await db.insert('habilidade', {
      'name': name,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// RELAÇÃO
  Future<void> insertPokemonHabilidade(
    int pokemonId,
    int habilidadeId,
    bool isHidden,
    int slot,
  ) async {
    final db = await DBHelper.database;

    await db.insert('pokemon_habilidade', {
      'pokemon_id': pokemonId,
      'habilidade_id': habilidadeId,
      'is_hidden': isHidden ? 1 : 0,
      'slot': slot,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// ⭐ GET HABILIDADES DO POKEMON (CORRIGIDO)
  Future<List<String>> getHabilidadesDoPokemon(int pokemonId) async {
    final db = await DBHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT h.name
      FROM habilidade h
      JOIN pokemon_habilidade ph ON ph.habilidade_id = h.id
      WHERE ph.pokemon_id = ?
      ORDER BY ph.slot
    ''',
      [pokemonId],
    );

    return result.map((e) => e['name'] as String).toList();
  }
}
