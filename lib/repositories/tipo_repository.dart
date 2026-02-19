import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';

class TipoRepository {
  /// ===============================
  /// INSERT TIPO
  /// ===============================
  Future<int> insertTipo(String name) async {
    final db = await DBHelper.database;

    final result = await db.query(
      'tipo',
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }

    return await db.insert('tipo', {
      'name': name,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// ===============================
  /// RELAÇÃO POKEMON_TIPO
  /// ===============================
  Future<void> insertPokemonTipo(int pokemonId, int tipoId, int slot) async {
    final db = await DBHelper.database;

    await db.insert('pokemon_tipo', {
      'pokemon_id': pokemonId,
      'tipo_id': tipoId,
      'slot': slot,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// ===============================
  /// ⭐ ESTE É O MÉTODO QUE FALTAVA
  /// ===============================
  Future<List<String>> getTiposDoPokemon(int pokemonId) async {
    final db = await DBHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT t.name
      FROM tipo t
      JOIN pokemon_tipo pt ON pt.tipo_id = t.id
      WHERE pt.pokemon_id = ?
      ORDER BY pt.slot
    ''',
      [pokemonId],
    );

    return result.map((e) => e['name'] as String).toList();
  }

  /// (alias opcional caso algum código antigo chame outro nome)
  Future<List<String>> getTiposPokemon(int pokemonId) =>
      getTiposDoPokemon(pokemonId);
}
