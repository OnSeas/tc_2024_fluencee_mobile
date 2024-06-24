import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/api/atividades-service.dart';
import 'package:tc_2024_fluencee_mobile/api/turmas-service.dart';
import 'package:tc_2024_fluencee_mobile/components/atividades/criar-editar-atividade.dart';
import 'package:tc_2024_fluencee_mobile/components/atividades/tela-incial-atividade.dart';
import 'package:tc_2024_fluencee_mobile/components/turmas/criar-editar-turma.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';

class TelaIncialTurmas extends StatefulWidget {
  final Turma turma;
  const TelaIncialTurmas({Key? key, required this.turma}) : super(key: key);

  @override
  State<TelaIncialTurmas> createState() => _TelaIncialTurmasState();
}

class _TelaIncialTurmasState extends State<TelaIncialTurmas> {
  int _selectedIndex = 0;
  bool _showActivityPage = true;
  late Future<List<Atividade>> atividades;

  TurmasService turmasService = TurmasService();
  AtividadeService atividadeService = AtividadeService();

  late Turma _currentTurma;

  @override
  void initState() {
    super.initState();
    _currentTurma = widget.turma;
    atividades = _carregarAtividades();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showActivityPage = index == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // App bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * MyApp.appBarHeight,
              color: Theme.of(context).canvasColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Seta de volta
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top, left: 10),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: _currentTurma.eProfessor ?? false,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top, right: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.grade),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            onPressed: () {
                              // TODO
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.settings),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditarTurma(
                                      turma: _currentTurma,
                                    ),
                                  )).then((value) => _atualizarTurma());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Página de atividades ou leaderboard
          Positioned.fill(
            top: MediaQuery.of(context).size.height * MyApp.appBarHeight,
            child: _showActivityPage
                ? _buildActivityPage()
                : _buildLeaderboardPage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).canvasColor,
        height: MediaQuery.of(context).size.height * MyApp.bottomAppBarHeight,
        surfaceTintColor: Theme.of(context).canvasColor,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.assignment),
                color: _selectedIndex == 0
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.grey,
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(Icons.leaderboard),
                color: _selectedIndex == 1
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.grey,
                onPressed: () => _onItemTapped(1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityPage() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _currentTurma.eProfessor ?? false
                        ? Icons.school
                        : Icons.person, // Ícone de Aluno
                    color: Theme.of(context).canvasColor,
                  ),
                  SizedBox(width: 10),
                  Text(
                    _currentTurma.nome ?? '',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 24),
                  Text(
                    'Professor: ${_currentTurma.professorNome ?? ''}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Sala e Ano
              if ((_currentTurma.sala != null &&
                      _currentTurma.sala!.isNotEmpty) ||
                  (_currentTurma.ano != null &&
                      _currentTurma.ano!.isNotEmpty)) ...[
                Row(
                  children: [
                    SizedBox(width: 24),
                    Text(
                      '${_currentTurma.sala ?? ''} - ${_currentTurma.ano ?? ''}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _atualizarListaAtividades,
                child: FutureBuilder<List<Atividade>>(
                  future: atividades,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar atividades'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text('Nenhuma atividade cadastrada.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Atividade atividade = snapshot.data![index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                                vertical: 10.0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(85, 88, 255, 0.35),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: Text(atividade.nome!),
                              trailing: (_currentTurma.eProfessor ?? false)
                                  ? IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Theme.of(context).canvasColor,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditarAtividade(
                                              turma: _currentTurma,
                                              atividade: atividade,
                                            ),
                                          ),
                                        ).then((value) =>
                                            _atualizarListaAtividades());
                                      },
                                    )
                                  : null,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TelaInicioAtividade(
                                          turma: widget.turma,
                                          atividade: atividade)),
                                ).then((value) => _atualizarListaAtividades());
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              if (_currentTurma.eProfessor ?? false)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarAtividade(
                            turma: _currentTurma,
                            atividade: Atividade(id: -1),
                          ),
                        ),
                      ).then((value) => _atualizarListaAtividades());
                    },
                    child: Icon(
                      Icons.add,
                      size: 32,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardPage() {
    return Center(
      child: Text(
        'Leaderboard',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Future<void> _atualizarTurma() async {
    final turmaAtualizada = await _carregarTurma();
    setState(() {
      _currentTurma = turmaAtualizada;
    });
  }

  Future<Turma> _carregarTurma() async {
    final resposta = await turmasService.getTurma(context, _currentTurma.id);
    if (resposta.isSucess()) {
      return resposta.object as Turma;
    } else if (resposta.isFatalError()) {
      await ApiService.deslogarUsuario();
      Navigator.popAndPushNamed(context, AppRoutes.TELA_LOGIN);
    }
    return Turma(id: -1);
  }

  Future<void> _atualizarListaAtividades() async {
    setState(() {
      atividades = _carregarAtividades();
    });
  }

  Future<List<Atividade>> _carregarAtividades() async {
    final resposta =
        await atividadeService.listarAtividades(context, _currentTurma);
    if (resposta.isSucess()) {
      return resposta.object as List<Atividade>;
    } else if (resposta.isFatalError()) {
      await ApiService.deslogarUsuario();
      Navigator.popAndPushNamed(context, AppRoutes.TELA_LOGIN);
    }
    return [];
  }
}
