import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/atividades-service.dart';
import 'package:tc_2024_fluencee_mobile/components/questoes/criar-editar-questao.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/Questao.dart';

class ListaQuestoes extends StatefulWidget {
  final Atividade atividade;

  const ListaQuestoes({super.key, required this.atividade});

  @override
  State<ListaQuestoes> createState() => _ListaQuestoesState();
}

class _ListaQuestoesState extends State<ListaQuestoes> {
  AtividadeService atividadeService = AtividadeService();
  late Future<List<Questao>> questoes;
  late Future<String> nota;

  @override
  void initState() {
    super.initState();
    _atualizarPagina();
  }

  Future<void> _atualizarPagina() async {
    setState(() {
      questoes = _carregarQuestoes();
      nota = _carregarNota();
    });
  }

  Future<List<Questao>> _carregarQuestoes() async {
    final resposta =
        await atividadeService.listarQuestoes(context, widget.atividade);
    if (resposta.isSucess()) {
      return resposta.object as List<Questao>;
    }
    return [];
  }

  Future<String> _carregarNota() async {
    double nota = 0.0;
    List<Questao> questoesList = await questoes;

    for (var questao in questoesList) {
      nota += questao.nota!;
    }

    return nota.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).scaffoldBackgroundColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: MediaQuery.of(context).size.height * MyApp.appBarHeight,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: RefreshIndicator(
        onRefresh: _atualizarPagina,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.0),
              Center(
                child: FutureBuilder<String>(
                  future: nota,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Erro ao carregar nota');
                    } else if (snapshot.hasData) {
                      return Text(
                        'Questões ${snapshot.data}/${widget.atividade.notaValor}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      );
                    } else {
                      return Text('Nenhuma nota disponível');
                    }
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Questao>>(
                  future: questoes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar questões'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Nenhuma questão cadastrada.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Questao questao = snapshot.data![index];
                          return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 10.0),
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: Text(questao.nome!),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Theme.of(context).canvasColor,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditarQuestao(
                                                      atividade:
                                                          widget.atividade,
                                                      questao: questao)),
                                        ).then((value) {
                                          _atualizarPagina();
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Theme.of(context).canvasColor,
                                      onPressed: () {
                                        deleteAlertDialog(context, questao);
                                      },
                                    ),
                                  ],
                                ),
                              ));
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          novaQuestaoDialog(context);
        },
        child: Icon(
          Icons.add,
          size: 32,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }

  novaQuestaoDialog(BuildContext context) {
    // botões
    Widget questaoDissertativaButton = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
        ),
        child: Text(
          "Questão Dissertativa",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color:
                    Theme.of(context).scaffoldBackgroundColor, // Cor do texto
              ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditarQuestao(
                    atividade: widget.atividade,
                    questao: Questao(id: -1, tipo: 1))),
          ).then((value) {
            _atualizarPagina();
            Navigator.pop(context);
          });
        },
      ),
    );

    Widget questaoMultiplaButton = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
        ),
        child: Text(
          "Questão de Múltipla escolha",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditarQuestao(
                    atividade: widget.atividade,
                    questao: Questao(id: -1, tipo: 2))),
          ).then((value) {
            _atualizarPagina();
            Navigator.pop(context);
          });
        },
      ),
    );

    Widget cancelarButton = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
        ),
        child: Text(
          "Cancelar",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    // O dialogo
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Criar questão",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10.0),
            Text(
              "Selecione uma opção",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      actions: [
        questaoDissertativaButton,
        SizedBox(height: 10.0),
        questaoMultiplaButton,
        SizedBox(height: 10.0),
        cancelarButton
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  deleteAlertDialog(BuildContext context, Questao questao) {
    // botões
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            width: 3.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
      ),
      child: Text(
        "Cancel",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary, // Cor do texto
            ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
      ),
      child: Text(
        "remover",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onPressed: () {
        atividadeService
            .removerQuestoes(context, questao.id, widget.atividade.id)
            .then((resposta) {
          _atualizarPagina();
          Navigator.pop(context);
        });
      },
    );

    // O dialogo
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Remover questão",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 10.0),
            Text(
              "Deseja remover a questão \"${questao.nome}\" da atividade?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // para aparecer o modal.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
