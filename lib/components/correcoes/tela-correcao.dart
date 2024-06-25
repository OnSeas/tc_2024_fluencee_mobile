import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tc_2024_fluencee_mobile/api/resposta-service.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Correcao.dart';
import 'package:tc_2024_fluencee_mobile/models/RespostaBD.dart';

class CorrecaoDissertativa extends StatefulWidget {
  final RespostaBD respostaBD;

  const CorrecaoDissertativa({super.key, required this.respostaBD});

  @override
  State<CorrecaoDissertativa> createState() => _CorrecaoDissertativaState();
}

class _CorrecaoDissertativaState extends State<CorrecaoDissertativa> {
  RespostaService respostaService = RespostaService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _comentarioController = TextEditingController();
  final _notaController = TextEditingController();

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
                          widget.respostaBD.nomeQuestao!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 40.0),
                        Text(
                          "Enunciado",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          widget.respostaBD.enunciadoQuestao!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 40.0),
                        Text(
                          "Resposta",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          widget.respostaBD.resposta,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _comentarioController,
                          decoration: InputDecoration(
                            labelText: 'Comentario',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um comentario';
                            } else if (value.length > 150) {
                              return 'Resposta deve ter entre 1 e 150 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          child: TextFormField(
                            style: Theme.of(context).textTheme.bodyLarge,
                            controller: _notaController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Nota *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor preencha o campo Nota!';
                              } else if (double.tryParse(value) == null ||
                                  double.parse(value) < 0) {
                                return 'Nota deve ser no minimo 0';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 40.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                respostaService
                                    .corrigir(
                                        context,
                                        Correcao(
                                            id: widget.respostaBD.id,
                                            resposta:
                                                widget.respostaBD.resposta,
                                            nota: double.parse(
                                                _notaController.text),
                                            comentario:
                                                _comentarioController.text))
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
          ),
        ],
      ),
    );
  }
}
