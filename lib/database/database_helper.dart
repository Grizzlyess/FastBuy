import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fastbuy_database.db');
    
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vendas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produto_id INTEGER,
        nome_produto TEXT,
        quantidade_vendida INTEGER,
        valor_total REAL,
        metodo_pagamento TEXT, -- NOVA COLUNA
        data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE produtos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        quantidade INTEGER,
        valor REAL,
        imagemPath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE vendas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produto_id INTEGER,
        nome_produto TEXT,
        quantidade_vendida INTEGER,
        valor_total REAL,
        data_venda TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE usuarios ADD COLUMN estabelecimento TEXT;");
    }
    
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE vendas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          produto_id INTEGER,
          nome_produto TEXT,
          quantidade_vendida INTEGER,
          valor_total REAL,
          data_venda TEXT
        )
      ''');
    }
  }
}