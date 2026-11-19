
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/produto.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _iniciarBanco();
    return _database!;
  }

  Future<Database> _iniciarBanco() async {
    final caminho = join(
      await getDatabasesPath(),
      'lista_compras.db',
    );

    return openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE produtos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            quantidade INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE - Adicionar produto
  Future<int> inserirProduto(Produto produto) async {
    final db = await database;

    return db.insert(
      'produtos',
      produto.toMap(),
    );
  }

  // READ - Listar produtos
  Future<List<Produto>> listarProdutos() async {
    final db = await database;

    final resultado = await db.query(
      'produtos',
      orderBy: 'id DESC',
    );

    return resultado.map((item) {
      return Produto.fromMap(item);
    }).toList();
  }

  // UPDATE - Editar produto
  Future<int> atualizarProduto(Produto produto) async {
    final db = await database;

    return db.update(
      'produtos',
      produto.toMap(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  // DELETE - Excluir produto
  Future<int> excluirProduto(int id) async {
    final db = await database;

    return db.delete(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
