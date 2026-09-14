import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarefa.dart';



class DatabaseHelper {


  static final DatabaseHelper instance =
      DatabaseHelper._init();


  DatabaseHelper._init();



  static Database? _database;



  Future<Database> get database async {


    if(_database != null){

      return _database!;

    }


    _database = await _initDatabase();


    return _database!;


  }




  Future<Database> _initDatabase() async {


    final path = join(

      await getDatabasesPath(),

      'tarefas.db',

    );



    return openDatabase(

      path,

      version: 1,


      onCreate: (db,version) async {


        await db.execute('''

        CREATE TABLE tarefas(

          id INTEGER PRIMARY KEY AUTOINCREMENT,

          titulo TEXT NOT NULL,

          concluida INTEGER NOT NULL

        )

        ''');


      },


    );


  }






  Future<void> inserir(Tarefa tarefa) async {


    final db = await database;


    await db.insert(

      'tarefas',

      tarefa.toMap(),

    );


  }






  Future<List<Tarefa>> buscarTodas() async {


    final db = await database;


    final resultado = await db.query(

      'tarefas',

      orderBy: 'concluida ASC',

    );



    return resultado.map(

      (e)=>Tarefa.fromMap(e),

    ).toList();


  }







  Future<void> atualizar(Tarefa tarefa) async {


    final db = await database;


    await db.update(

      'tarefas',

      tarefa.toMap(),


      where:'id = ?',


      whereArgs:[tarefa.id],


    );


  }







  Future<void> remover(int id) async {


    final db = await database;


    await db.delete(

      'tarefas',

      where:'id = ?',


      whereArgs:[id],


    );


  }






  Future<void> apagarTudo() async {


    final db = await database;


    await db.delete(

      'tarefas',

    );


  }


}
