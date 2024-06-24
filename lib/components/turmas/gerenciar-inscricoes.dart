import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/turmas-service.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Estudante.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';

class TelaGerenciarInscricoes extends StatefulWidget {
  final Turma turma;

  const TelaGerenciarInscricoes({super.key, required this.turma});

  @override
  State<TelaGerenciarInscricoes> createState() =>
      _TelaGerenciarInscricoesState();
}

class _TelaGerenciarInscricoesState extends State<TelaGerenciarInscricoes> {
  TurmasService turmasService = TurmasService();
  late Future<List<Estudante>> estudantes;

  @override
  void initState() {
    estudantes = turmasService.ListarEstudantes(context, widget.turma);
    super.initState();
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0),
            Center(
              child: Text(
                widget.turma.codigo!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            SizedBox(height: 30.0),
            Center(
              child: Text(
                'Alunos',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Estudante>>(
                future: estudantes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar alunos'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Nenhum aluno encontrado'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Estudante estudante = snapshot.data![index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 10.0),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(estudante.nome!),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).colorScheme.error,
                              onPressed: () {
                                deleteAlertDialog(context, estudante);
                              },
                            ),
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
    );
  }

  deleteAlertDialog(BuildContext context, Estudante estudante) {
    Widget removerAlunoButton = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
        ),
        child: Text(
          "Remover Aluno",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
        ),
        onPressed: () {
          bloquearAlertDialog(context, estudante);
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
              "Remover aluno",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10.0),
            Text(
              "Tem certeza que deseja remover o aluno?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      actions: [removerAlunoButton, SizedBox(height: 10.0), cancelarButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bloquearAlertDialog(BuildContext context, Estudante estudante) {
    Widget bloquearAlunoButton = Container(
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
          "Bloquear",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
        ),
        onPressed: () {
          turmasService
              .excluirEstudante(context, estudante, true)
              .then((resposta) {
            if (resposta.isSucess()) {
              _atualizarAlunos();
              Navigator.pop(context);
              Navigator.pop(context);
            }
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
          backgroundColor: Theme.of(context).colorScheme.error,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
        ),
        child: Text(
          "Apenas remover",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        onPressed: () {
          turmasService
              .excluirEstudante(context, estudante, false)
              .then((resposta) {
            if (resposta.isSucess()) {
              _atualizarAlunos();
              Navigator.pop(context);
              Navigator.pop(context);
            }
          });
        },
      ),
    );

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
              "Deseja bloquear o aluno?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      actions: [bloquearAlunoButton, SizedBox(height: 10.0), cancelarButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _atualizarAlunos() {
    setState(() {
      estudantes = turmasService.ListarEstudantes(context, widget.turma);
    });
  }
}
