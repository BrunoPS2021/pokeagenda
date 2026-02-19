import '../database/db_helper.dart';

class SpriteRepository {
  Future<void> insertSprite(int pokemonId, String url, String tipo) async {
    final db = await DBHelper.database;

    await db.insert('sprite', {
      'pokemon_id': pokemonId,
      'url': url,
      'tipo_imagem': tipo,
    });
  }
}
