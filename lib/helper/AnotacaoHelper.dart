import 'dart:developer';
import 'package:anotations/model/anotacao.dart';
import 'package:anotations/model/produtos.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {
  static final String nomeTabela = "anotacao";
  static final String colunaId = "id";
  static final String colunaTitulo = "titulo";
  static final String colunaDescricao = "descricao";
  static final String colunaData = "data";

  static final String tabelaProduto = "produtos";
  static final String colunaIdProduto = "idProduto";
  static final String idFeira = "idFeira";
  static final String colunaProduto = "colunaProduto";
  static final String colunaQuantidade = "colunaQuantidade";
  static final String isCompleted = "isCompleted";

  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database? _db;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql1 =
        "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)";
    String sqlProduto =
        "CREATE TABLE $tabelaProduto (idProduto INTEGER PRIMARY KEY AUTOINCREMENT, idFeira INTEGER, colunaProduto VARCHAR, colunaQuantidade VARCHAR, isCompleted INTEGER)";

    await db.execute(sql1);
    await db.execute(sqlProduto);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco3.db");

    var db =
        await openDatabase(localBancoDados, version: 2, onCreate: _onCreate);
    return db;
  }

//////////////////
  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;

    int resultado = await bancoDados.insert(nomeTabela, anotacao.toMap());
    return resultado;
  }

  recuperarAnotacoes() async {
    var bancoDados = await db;
    String sql =
        "SELECT * FROM $nomeTabela ORDER BY data DESC "; // listar pela data
    List anotacoes = await bancoDados.rawQuery(sql);
    return anotacoes;
  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    log(anotacao.id.toString());
    return await bancoDados
        .update(nomeTabela, anotacao.toMap(), where: "id = ?", whereArgs: [
      anotacao.id,
    ]);
  }

  Future<int> removerAnotacao(int id) async {
    var bancoDados = await db;
    return await bancoDados.delete(
      nomeTabela,
      where: "id = ?",
      whereArgs: [id],
    );
  }

/////////////////////
  Future<int> salvarProduto(Produto produto) async {
    var bancoDados = await db;

    int resultado = await bancoDados.insert(tabelaProduto, produto.toMap());
    return resultado;
  }

  recuperarProdutos(int id) async {
    var bancoDados = await db;
    //String sql =
    //("SELECT * FROM $tabelaProduto WHERE idFeira = ?"); // listar pela data
    List produtos = await bancoDados
        .rawQuery("SELECT * FROM $tabelaProduto WHERE idFeira = ?", [id]);
    log("LISTA: " + produtos.toList().toString());
    return produtos;
  }

  Future<int> removerProduto(int id) async {
    var bancoDados = await db;
    return await bancoDados.delete(
      tabelaProduto,
      where: "idProduto = ?",
      whereArgs: [id],
    );
  }

  Future<int> atualizarProduto(Produto produto) async {
    var bancoDados = await db;
    log("ok: " + produto.id.toString());
    return await bancoDados.update(tabelaProduto, produto.toMap(),
        where: "idProduto = ?", whereArgs: [6]);
  }

  foiCompleto(int id, int completo) async {
    var bancoDados = await db;
    log("ID: " + id.toString() + " - OK: " + completo.toString());
    return await bancoDados.rawUpdate(
        'UPDATE $tabelaProduto SET $isCompleted = ? WHERE $colunaIdProduto = ?',
        [
          completo,
          id,
        ]);
  }
}
