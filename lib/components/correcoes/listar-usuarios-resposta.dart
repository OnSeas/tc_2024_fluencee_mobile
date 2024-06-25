import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/resposta-service.dart';
import 'package:tc_2024_fluencee_mobile/components/correcoes/RespostasQuestoes.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/EstudanteGrupo.dart';

class UsuarioResposta extends StatefulWidget {
  final Atividade atividade;
  const UsuarioResposta({super.key, required this.atividade});

  @override
  State<UsuarioResposta> createState() => _UsuarioRespostaState();
}

class _UsuarioRespostaState extends State<UsuarioResposta> {
  RespostaService respostaService = RespostaService();
  late Future<List<EstudanteGrupo>> respostasGrupo;

  @override
  void initState() {
    super.initState();
    _atualizarPagina();
  }

  Future<void> _atualizarPagina() async {
    setState(() {
      respostasGrupo = _carregarRespostas();
    });
  }

  Future<List<EstudanteGrupo>> _carregarRespostas() async {
    final resposta =
        await respostaService.listarRespostas(context, widget.atividade);
    if (resposta.isSucess()) {
      return resposta.object as List<EstudanteGrupo>;
    }
    return [];
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
                child: Text(
                  'Respostas dos Estudantes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<EstudanteGrupo>>(
                  future: respostasGrupo,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar respostas'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text('Nenhuma resposta cadastrada.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          EstudanteGrupo estudanteGrupo = snapshot.data![index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10.0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: Text(estudanteGrupo.estudante.nome!),
                              trailing: Icon(Icons.assignment_turned_in,
                                  color: Theme.of(context).colorScheme.primary),
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RespostaQuestao(
                                                    estudanteGrupo:
                                                        estudanteGrupo)))
                                    .then((value) => _atualizarPagina());
                              },
                            ),
                          );
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
