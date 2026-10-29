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

  Future<void> atualizarEstoquePosVenda(int idProduto, int quantidadeVendida, double valorTotal, String nomeProduto) async {
    Database db = await dbHelper.database; 
    
    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE produtos SET quantidade = quantidade - ? WHERE id = ?',
        [quantidadeVendida, idProduto]
      );
      await txn.rawInsert(
        'INSERT INTO vendas (produto_id, nome_produto, quantidade_vendida, valor_total, data_venda) VALUES (?, ?, ?, ?, ?)',
        [idProduto, nomeProduto, quantidadeVendida, valorTotal, DateTime.now().toIso8601String()]
      );
    });
  }


  Future<List<Map<String, dynamic>>> getTop5MaisVendidos() async {
    Database db = await dbHelper.database;
    return await db.rawQuery('''
      SELECT nome_produto, SUM(quantidade_vendida) as total 
      FROM vendas 
      GROUP BY produto_id 
      ORDER BY total DESC 
      LIMIT 5
    ''');
  }

Future<List<Map<String, dynamic>>> getTop5MenosVendidos() async {
    Database db = await dbHelper.database;
    return await db.rawQuery('''
      SELECT p.nome as nome_produto, IFNULL(SUM(v.quantidade_vendida), 0) as total 
      FROM produtos p
      LEFT JOIN vendas v ON p.id = v.produto_id 
      GROUP BY p.id 
      ORDER BY total ASC 
      LIMIT 5
    ''');
  }

  Future<List<Map<String, dynamic>>> getFaturamentoUltimos5Dias() async {
    Database db = await dbHelper.database;
    return await db.rawQuery('''
      SELECT date(data_venda) as data, SUM(valor_total) as total 
      FROM vendas 
      GROUP BY date(data_venda) 
      ORDER BY data DESC 
      LIMIT 5
    ''');
  }

  Future<List<Map<String, dynamic>>> getFaturamentoUltimas5Semanas() async {
    Database db = await dbHelper.database;
    return await db.rawQuery('''
      SELECT strftime('%W', data_venda) as semana, SUM(valor_total) as total 
      FROM vendas 
      GROUP BY strftime('%W', data_venda) 
      ORDER BY semana DESC 
      LIMIT 5
    ''');
  }

  Future<List<Map<String, dynamic>>> getTransacoesPorData(String dataIso) async {
  Database db = await dbHelper.database;
  return await db.rawQuery('''
    SELECT nome_produto, quantidade_vendida, valor_total, metodo_pagamento, time(data_venda) as hora
    FROM vendas 
    WHERE date(data_venda) = ?
    ORDER BY data_venda DESC
  ''', [dataIso]);
}
}