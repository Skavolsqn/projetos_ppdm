import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/tarefa.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();

    return _database!;
  }

  Future<Database> _initDB() async {
    databaseFactory = databaseFactoryFfiWeb;

    return await databaseFactory.openDatabase(
      'tarefas.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDB,
      ),
    );
  }

  Future<void> _createDB(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        concluida INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<List<Tarefa>> queryAll() async {
    final db = await database;

    final result = await db.query(
      'tarefas',
      orderBy: 'id DESC',
    );

    return result.map((map) {
      return Tarefa.fromMap(map);
    }).toList();
  }

  Future<List<Tarefa>> search(String texto) async {
    final db = await database;

    final result = await db.query(
      'tarefas',
      where: 'titulo LIKE ?',
      whereArgs: ['%$texto%'],
      orderBy: 'id DESC',
    );

    return result.map((map) {
      return Tarefa.fromMap(map);
    }).toList();
  }

  Future<int> insert(Tarefa tarefa) async {
    final db = await database;

    return await db.insert(
      'tarefas',
      tarefa.toMap(),
    );
  }

  Future<int> update(Tarefa tarefa) async {
    final db = await database;

    return await db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await database;

    return await db.delete('tarefas');
  }
}