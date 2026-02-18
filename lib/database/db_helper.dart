import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final String appDir = await getDatabasesPath();
    final String path = join(appDir, 'pokeagenda.db');

    print('Banco criado em: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabela Pokémon
        await db.execute('''
          CREATE TABLE pokemon(
            id INTEGER PRIMARY KEY,
            name TEXT,
            url TEXT,
            height INTEGER,
            weight INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE tipo(
            id INTEGER PRIMARY KEY,
            name TEXT UNIQUE
          )
        ''');

        await db.execute('''
          CREATE TABLE pokemon_tipo(
            pokemon_id INTEGER,
            tipo_id INTEGER,
            slot INTEGER,
            FOREIGN KEY(pokemon_id) REFERENCES pokemon(id),
            FOREIGN KEY(tipo_id) REFERENCES tipo(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE habilidade(
            id INTEGER PRIMARY KEY,
            name TEXT UNIQUE
          )
        ''');

        await db.execute('''
          CREATE TABLE pokemon_habilidade(
            pokemon_id INTEGER,
            habilidade_id INTEGER,
            is_hidden INTEGER,
            slot INTEGER,
            FOREIGN KEY(pokemon_id) REFERENCES pokemon(id),
            FOREIGN KEY(habilidade_id) REFERENCES habilidade(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE stat(
            id INTEGER PRIMARY KEY,
            name TEXT UNIQUE
          )
        ''');

        await db.execute('''
          CREATE TABLE pokemon_stat(
            pokemon_id INTEGER,
            stat_id INTEGER,
            base_stat INTEGER,
            effort INTEGER,
            FOREIGN KEY(pokemon_id) REFERENCES pokemon(id),
            FOREIGN KEY(stat_id) REFERENCES stat(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE sprite(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pokemon_id INTEGER,
            url TEXT,
            tipo_imagem TEXT,
            FOREIGN KEY(pokemon_id) REFERENCES pokemon(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE evolucao(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pokemon_id INTEGER,
            evolui_para_id INTEGER,
            metodo TEXT,
            nivel INTEGER,
            FOREIGN KEY(pokemon_id) REFERENCES pokemon(id),
            FOREIGN KEY(evolui_para_id) REFERENCES pokemon(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE historico_atualizacao(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            count_pokemons INTEGER,
            data_ultima_atualizacao TEXT,
            sucesso INTEGER
          )
        ''');
      },
    );
  }

  /// Deleta o banco (para testes)
  static Future<void> deleteDB() async {
    final String appDir = await getDatabasesPath();
    final String path = join(appDir, 'pokeagenda.db');
    await deleteDatabase(path);
    print('Banco deletado em: $path');
  }
}
