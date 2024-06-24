import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/resposta-service.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/Questao.dart';
import 'package:tc_2024_fluencee_mobile/models/Respostabd.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';

class ResponderQuestao extends StatefulWidget {
  final Turma turma;
  final Atividade atividade;
  final Questao questao;

  const ResponderQuestao(
      {super.key,
      required this.questao,
      required this.atividade,
      required this.turma});

  @override
  State<ResponderQuestao> createState() => _ResponderQuestaoState();
}

class _ResponderQuestaoState extends State<ResponderQuestao> {
  RespostaService respostaService = RespostaService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _respostaController = TextEditingController();

  @override
  void dispose() {
    _respostaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.questao.nome!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 40.0),
                        Text(
                          "Enunciado",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          widget.questao.enunciado!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 40.0),
                        TextFormField(
                          controller: _respostaController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Resposta',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira uma resposta';
                            } else if (value.length > 150) {
                              return 'Resposta deve ter entre 1 e 150 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                respostaService
                                    .responder(
                                        context,
                                        widget.questao,
                                        widget.atividade,
                                        RespostaBD(
                                            id: 0,
                                            resposta: _respostaController.text))
                                    .then((resposta) {
                                  if (resposta.isSucess()) {
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              'Responder',
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
          ),
        ],
      ),
    );
  }
}
