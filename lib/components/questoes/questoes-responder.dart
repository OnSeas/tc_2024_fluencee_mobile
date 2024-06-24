import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/atividades-service.dart';
import 'package:tc_2024_fluencee_mobile/components/questoes/questao-responder.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/Questao.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';

class ResponderQuestoes extends StatefulWidget {
  final Turma turma;
  final Atividade atividade;

  const ResponderQuestoes(
      {super.key, required this.turma, required this.atividade});

  @override
  State<ResponderQuestoes> createState() => _ResponderQuestoesState();
}

class _ResponderQuestoesState extends State<ResponderQuestoes> {
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
    // Pode calcular a nota do aluno aqui, depois que a atividade já estiver corrigida.
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
                                    if (!questao.respondida!)
                                      IconButton(
                                        icon: Icon(Icons.arrow_upward),
                                        color: Theme.of(context).canvasColor,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ResponderQuestao(
                                                      turma: widget.turma,
                                                      atividade:
                                                          widget.atividade,
                                                      questao: questao,
                                                    )),
                                          ).then((value) => _atualizarPagina());
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
    );
  }
}
