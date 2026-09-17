import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fastbuy.db'); 
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);


    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

    Future _createDB(Database db, int version) async {
        await db.execute('''
        CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            senha TEXT NOT NULL
        )
        ''');
  }

  Future<int> cadastrarUsuario(String nome, String email, String senha) async {
    final db = await instance.database;

    final dadosUsuario = {
      'nome': nome,
      'email': email,
      'senha': senha, 
    };
    return await db.insert('usuarios', dadosUsuario);
  }
}