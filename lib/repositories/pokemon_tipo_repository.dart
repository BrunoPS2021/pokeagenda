import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';

class PokemonTipoRepository {
  Future<void> insert(int pokemonId, int tipoId, int slot) async {
    final db = await DBHelper.database;

    await db.insert('pokemon_tipo', {
      'pokemon_id': pokemonId,
      'tipo_id': tipoId,
      'slot': slot,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }
}
