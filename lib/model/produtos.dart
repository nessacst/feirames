//import 'dart:ffi';

import 'package:anotations/helper/AnotacaoHelper.dart';

class Produto {
  int? id;
  int? idFeira;
  String? tituloProduto;
  String? quantidade;
  int? isCompleted;

  Produto(this.idFeira, this.tituloProduto, this.quantidade, this.isCompleted);

  Produto.fromMap(Map map) {
    this.id = map[AnotacaoHelper.colunaIdProduto];
    this.idFeira = map[AnotacaoHelper.idFeira];
    this.tituloProduto = map[AnotacaoHelper.colunaProduto];
    this.quantidade = map[AnotacaoHelper.colunaQuantidade];
    this.isCompleted = map[AnotacaoHelper.isCompleted];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "idFeira": this.idFeira,
      "colunaProduto": this.tituloProduto,
      "colunaQuantidade": this.quantidade,
      "isCompleted": this.isCompleted,
    };

    if (id != null) {
      map["idProduto"] = id;
    }

    return map;
  }
}
