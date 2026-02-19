import '../database/db_helper.dart';

class EvolucaoRepository {
  Future<void> insertEvolucao(
    int de,
    int para,
    String metodo,
    int? nivel,
  ) async {
    final db = await DBHelper.database;

    await db.insert('evolucao', {
      'pokemon_id': de,
      'evolui_para_id': para,
      'metodo': metodo, // ⭐ AQUI ERA O BUG
      'nivel': nivel,
    });
  }

  /// NOME DA EVOLUÇÃO
  Future<String?> getEvolucaoNome(int pokemonId) async {
    final db = await DBHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT p.name
      FROM pokemon p
      JOIN evolucao e ON e.evolui_para_id = p.id
      WHERE e.pokemon_id = ?
      LIMIT 1
    ''',
      [pokemonId],
    );

    if (result.isEmpty) return null;

    return result.first['name'] as String;
  }
}
