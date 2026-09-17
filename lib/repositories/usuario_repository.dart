import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/usuario_model.dart';

class UsuarioRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> cadastrarUsuario(Usuario usuario) async {
    Database db = await dbHelper.database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<bool> verificarLogin(String email, String senha) async {
    Database db = await dbHelper.database;
    
    List<Map<String, dynamic>> resultado = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    
    return resultado.isNotEmpty;
  }
}