import 'dart:developer';

import 'package:anotations/helper/AnotacaoHelper.dart';
import 'package:anotations/model/anotacao.dart';
import 'package:anotations/model/produtos.dart';
import 'package:flutter/material.dart';

class TelaProdutos extends StatefulWidget {
  final int id;
  final String titulo;
  TelaProdutos({Key? key, required this.id, required this.titulo})
      : super(key: key);

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  final TextEditingController _tituloProdutoController =
      TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();

  var _db = AnotacaoHelper();
  List<Produto> _produtos = [];

  _exibirTelaProdutos({Produto? produto}) {
    String textoSalvarAtualizar = "";
    if (produto == null) {
      _tituloProdutoController.text = "";
      _quantidadeController.text = "";
      textoSalvarAtualizar = "Salvar";
    } else {
      _tituloProdutoController.text = produto.tituloProduto.toString();
      _quantidadeController.text = produto.quantidade.toString();
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (conttext) {
          return AlertDialog(
            title: Text("$textoSalvarAtualizar produto"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloProdutoController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Produto",
                    labelStyle: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: "Arroz, feijão...",
                  ),
                ),
                TextField(
                  controller: _quantidadeController,
                  decoration: InputDecoration(
                    labelText: "Quantidade",
                    labelStyle: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: "1, 2, 3...",
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.cyan),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.cyan),
                ),
                onPressed: () {
                  //salvar
                  _salvarAtualizarProduto(produtoSelecionado: produto);

                  Navigator.pop(context);
                },
                child: Text(textoSalvarAtualizar),
              ),
            ],
          );
        });
  }

  _salvarAtualizarProduto({Produto? produtoSelecionado}) async {
    String tituloProduto = _tituloProdutoController.text;
    String quantidadeProduto = _quantidadeController.text;

    if (produtoSelecionado == null) {
      // salvar anotação
      Produto produto = Produto(widget.id, tituloProduto, quantidadeProduto, 0);
      int resultado = await _db.salvarProduto(produto);
    } else {
      produtoSelecionado.tituloProduto = tituloProduto;
      produtoSelecionado.quantidade = quantidadeProduto;
      int resultado = await _db.atualizarProduto(produtoSelecionado);
    }

    _tituloProdutoController.clear();
    _quantidadeController.clear();
    _recuperarProdutos();
  }

  _recuperarProdutos() async {
    List produtosRecuperados = await _db.recuperarProdutos(widget.id);

    List<Produto> listaTemporaria = [];

    for (var item in produtosRecuperados) {
      Produto produto = Produto.fromMap(item);
      listaTemporaria.add(produto);
    }

    setState(() {
      _produtos = listaTemporaria;
    });
  }

  _removerProduto(int id) async {
    await _db.removerProduto(id);
    _recuperarProdutos();
  }

  _completo(int id, int ok) async {
    await _db.foiCompleto(id, ok);
    _recuperarProdutos();
  }

  @override
  void initState() {
    super.initState();
    _recuperarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    bool? isCompleted = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _exibirTelaProdutos();
              });
            },
            icon: Icon(Icons.add_circle_outline),
            iconSize: 30,
            padding: EdgeInsets.fromLTRB(3, 3, 23, 3),
          )
        ],
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: _produtos.isNotEmpty
                ? ListView.builder(
                    itemCount: _produtos.length,
                    itemBuilder: (context, index) {
                      final produto = _produtos[index];

                      return Column(
                        children: [
                          Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: produto.isCompleted == 0
                                  ? Theme.of(context).cardColor
                                  : Colors.green,
                              padding: EdgeInsets.all(16),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            onDismissed: (direction) {
                              _removerProduto(produto.id!);
                            },
                            key: Key(produto.id!.toString()),
                            child: ListTile(
                              title: Text(
                                produto.tituloProduto!,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: produto.isCompleted == 0
                                        ? TextDecoration.none
                                        : TextDecoration.lineThrough,
                                    color: produto.isCompleted == 0
                                        ? Colors.green
                                        : Colors.red),
                              ),
                              subtitle: Text(
                                "Qtd: " + produto.quantidade!,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _exibirTelaProdutos(produto: produto);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 16),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey,
                                    width: 20,
                                    thickness: 0.1,
                                  ),
                                  Checkbox(
                                      activeColor: Colors.green[900],
                                      value: produto.isCompleted == 0
                                          ? false
                                          : true,
                                      onChanged: (value) {
                                        setState(() {
                                          //isCompleted[index] = true;
                                          int ok = value == false ? 0 : 1;
                                          log(ok.toString());
                                          _completo(produto.id!, ok);
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            indent: 40,
                            endIndent: 40,
                            thickness: 0.2,
                          )
                        ],
                      );
                    })
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _exibirTelaProdutos();
                        },
                        child: Icon(
                          Icons.add_circle,
                          size: 100,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "NOVO PRODUTO",
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
