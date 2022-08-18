import 'package:anotations/helper/AnotacaoHelper.dart';
import 'package:anotations/model/anotacao.dart';
import 'package:anotations/page/telaPrdutos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Inicial extends StatefulWidget {
  @override
  State<Inicial> createState() => _InicialState();
}

class _InicialState extends State<Inicial> with AutomaticKeepAliveClientMixin {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

  _exibirTelaCadastro({Anotacao? anotacao}) {
    String textoSalvarAtualizar = "";
    if (anotacao == null) {
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    } else {
      _tituloController.text = anotacao.titulo.toString();
      _descricaoController.text = anotacao.descricao.toString();
      textoSalvarAtualizar = "Atualizar";
    }
    showDialog(
        context: context,
        builder: (conttext) {
          return AlertDialog(
            title: Text("$textoSalvarAtualizar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    labelStyle: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: "Digite o mês...",
                  ),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                    labelText: "Valor",
                    labelStyle: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: "  Digite o valor total...",
                    prefixText: "R\$",
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
                  _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);

                  Navigator.pop(context);
                },
                child: Text(textoSalvarAtualizar),
              ),
            ],
          );
        });
  }

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<Anotacao> listaTemporaria = [];

    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }

    setState(() {
      _anotacoes = listaTemporaria;
    });
    listaTemporaria = [];
  }

  _salvarAtualizarAnotacao({Anotacao? anotacaoSelecionada}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if (anotacaoSelecionada == null) {
      // salvar anotação
      Anotacao anotacao =
          Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao);
    } else {
      // atualizar
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacoes();
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");

    // var formatador = DateFormat("d/MMM/y H:m:s");
    var formatador = DateFormat.yMd("pt_BR");
    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _removerAnotacao(int id) async {
    await _db.removerAnotacao(id);
    _recuperarAnotacoes();
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Feiras"),
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              shadowColor: Colors.grey,
              elevation: 5,
              color: Colors.blue[100],
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          'Olá \n Bem vindo(a)!',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 20, color: Colors.blue[900]),
                        ),
                        Spacer(),
                        Icon(
                          Icons.shopping_cart_sharp,
                          size: 60,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.orange[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Listas de feiras',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _anotacoes.isNotEmpty
                  ? ListView.builder(
                      itemCount: _anotacoes.length,
                      itemBuilder: (context, index) {
                        final anotacao = _anotacoes[index];

                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
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
                            _removerAnotacao(anotacao.id!);
                          },
                          key: Key(anotacao.id!.toString()),
                          child: Card(
                            elevation: 4,
                            child: InkWell(
                              splashColor: Colors.black,
                              onTap: () {
                                // chama a tela com a lista de todos os produtos da feira
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TelaProdutos(
                                        id: anotacao.id!,
                                        titulo: anotacao.titulo!,
                                      ),
                                    ));
                              },
                              child: ListTile(
                                title: Text(anotacao.titulo!),
                                subtitle: Text(
                                    "${_formatarData(anotacao.data.toString())} - R\$ ${anotacao.descricao}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _exibirTelaCadastro(anotacao: anotacao);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.cyan,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            _exibirTelaCadastro();
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
                            "CLIQUE PARA ADICIONAR UMA NOVA FEIRA",
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _exibirTelaCadastro();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
