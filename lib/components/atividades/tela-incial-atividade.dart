import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/atividades-service.dart';
import 'package:tc_2024_fluencee_mobile/components/correcoes/listar-usuarios-resposta.dart';
import 'package:tc_2024_fluencee_mobile/components/questoes/questoes-responder.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';

class TelaInicioAtividade extends StatefulWidget {
  final Turma turma;
  final Atividade atividade;

  const TelaInicioAtividade(
      {super.key, required this.turma, required this.atividade});

  @override
  State<TelaInicioAtividade> createState() => _TelaInicioAtividadeState();
}

class _TelaInicioAtividadeState extends State<TelaInicioAtividade> {
  AtividadeService atividadeService = AtividadeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          height: MediaQuery.of(context).size.height * MyApp.appBarHeight,
          color: Theme.of(context).canvasColor,
        ),
      ),

      //Seta de volta
      Positioned(
        top: MediaQuery.of(context).padding.top,
        left: 10,
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).scaffoldBackgroundColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      // Conteudo da página
      Positioned(
        top: MediaQuery.of(context).size.height * 0.1,
        left: 0,
        right: 0,
        bottom: 0,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.atividade.nome!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Individual",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 80.0),
                  Text(
                    "Orientação",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    widget.atividade.enunciado!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 80.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.turma.eProfessor!) {
                          if (widget.atividade.status! == 1) {
                            atividadeService
                                .iniciarAtividade(context, widget.atividade)
                                .then((resposta) {
                              if (resposta.isSucess()) {
                                Navigator.pop(context);
                              }
                            });
                          }
                        } else {
                          if (widget.atividade.status! == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResponderQuestoes(
                                      turma: widget.turma,
                                      atividade: widget.atividade)),
                            );
                          } else {
                            naoIniciadaAlertDialog(context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.turma.eProfessor!
                            ? (widget.atividade.status! == 1
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.error)
                            : Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        widget.turma.eProfessor!
                            ? (widget.atividade.status! == 1
                                ? 'Iniciar atividade'
                                : 'Finalizar Atividade')
                            : 'Responder',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.bodyLarge!.fontFamily,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  if (widget.turma.eProfessor! && widget.atividade.status! > 1)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UsuarioResposta(
                                      atividade: widget.atividade,
                                    )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Corrigir',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .fontFamily,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]));
  }

  naoIniciadaAlertDialog(BuildContext context) {
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
        "Okay",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary, // Cor do texto
            ),
      ),
      onPressed: () {
        Navigator.pop(context);
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
              "Atividade não iniciada",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 10.0),
            Text(
              "Esta atividade ainda não foi inicializada pelo professor!",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
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
