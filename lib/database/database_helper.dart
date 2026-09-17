import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Padrão Singleton para garantir apenas uma instância do banco
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Define o caminho onde o arquivo do banco será salvo no celular
    String path = join(await getDatabasesPath(), 'fastbuy_database.db');
    
    return await openDatabase(
      path,
      version: 2, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        estabelecimento TEXT,
        email TEXT,
        senha TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE usuarios ADD COLUMN estabelecimento TEXT;");
    }
  }

  // MÉTODOS DO BACKEND

  Future<int> cadastrarUsuario(String nome, String estabelecimento, String email, String senha) async {
    Database db = await instance.database;
    return await db.insert('usuarios', {
      'nome': nome,
      'estabelecimento': estabelecimento,
      'email': email,
      'senha': senha,
    });
  }

  Future<bool> verificarLogin(String email, String senha) async {
    Database db = await instance.database;
    
    List<Map<String, dynamic>> resultado = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    
    return resultado.isNotEmpty;
  }
}