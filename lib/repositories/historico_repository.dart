import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/historico_atualizacao.dart';

class HistoricoRepository {
  Future<void> insertHistorico(HistoricoAtualizacao hist) async {
    final db = await DBHelper.database;

    await db.insert(
      'historico_atualizacao',
      hist.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<HistoricoAtualizacao?> getLastSuccessfulUpdate() async {
    final db = await DBHelper.database;

    final maps = await db.query(
      'historico_atualizacao',
      where: 'sucesso = ?',
      whereArgs: [1],
      orderBy: 'data_ultima_atualizacao DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;

    return HistoricoAtualizacao.fromMap(maps.first);
  }
}
