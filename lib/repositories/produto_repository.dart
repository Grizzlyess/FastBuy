import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/produto_model.dart';

class ProdutoRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> cadastrarProduto(Produto produto) async {
    Database db = await dbHelper.database;
    return await db.insert('produtos', produto.toMap());
  }

  Future<List<Produto>> listarProdutos() async {
    Database db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('produtos');
    
    return List.generate(maps.length, (i) {
      return Produto.fromMap(maps[i]);
    });
    
  }

  Future<int> atualizarProduto(Produto produto) async {
    Database db = await dbHelper.database; 
    
    return await db.update(
      'produtos',
      produto.toMap(), 
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }
}