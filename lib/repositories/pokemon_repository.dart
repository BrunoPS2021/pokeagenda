import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/pokemon.dart';

class PokemonRepository {
  Future<void> insertPokemon(Pokemon pokemon) async {
    final db = await DBHelper.database;

    await db.insert(
      'pokemon',
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pokemon>> getAllPokemons() async {
    final db = await DBHelper.database;

    final result = await db.query('pokemon', orderBy: 'id');

    return result.map((e) => Pokemon.fromMap(e)).toList();
  }

  Future<Pokemon?> getPokemonByName(String name) async {
    final db = await DBHelper.database;

    final result = await db.query(
      'pokemon',
      where: 'name=?',
      whereArgs: [name],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return Pokemon.fromMap(result.first);
  }

  /// FAVORITO
  Future<void> toggleFavorito(int id, bool fav) async {
    final db = await DBHelper.database;

    await db.update(
      'pokemon',
      {'favorito': fav ? 1 : 0},
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
