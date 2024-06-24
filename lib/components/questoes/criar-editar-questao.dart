import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tc_2024_fluencee_mobile/api/questao-service.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/Questao.dart';

class EditarQuestao extends StatefulWidget {
  final Atividade atividade;
  final Questao questao;

  const EditarQuestao(
      {super.key, required this.atividade, required this.questao});

  @override
  State<EditarQuestao> createState() => _EditarQuestaoState();
}

class _EditarQuestaoState extends State<EditarQuestao> {
  QuestaoService questaoService = QuestaoService();

  final _form = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _enunciadoController = TextEditingController();
  final _notaController = TextEditingController();

  @override
  void initState() {
    print(widget.questao);

    if (widget.questao.id != -1) {
      _nomeController.text = widget.questao.nome!;
      _enunciadoController.text = widget.questao.enunciado!;
      _notaController.text = widget.questao.nota!.toString();
    }
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.questao.id == -1
                          ? 'Criar Questão'
                          : "Editar Questão",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      widget.questao.tipo == 1
                          ? 'Questão dissertativa'
                          : "Questão de multipla-escolha",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      'Preencha os dados da questão abaixo: ',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                    //Form
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: TextFormField(
                              style: Theme.of(context).textTheme.bodyLarge,
                              controller: _nomeController,
                              decoration: InputDecoration(
                                labelText: 'Nome *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor preencha o campo Nome!';
                                } else if (value.length < 3 ||
                                    value.length > 40) {
                                  return 'Nome da questão deve ter entre 3 e 40 caracteres';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.16,
                            child: TextFormField(
                              style: Theme.of(context).textTheme.bodyLarge,
                              controller: _enunciadoController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: 'Enunciado *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor preencha o campo Enunciado!';
                                } else if (value.length > 100 ||
                                    value.length < 3) {
                                  return 'O Enunciado da questão deve ter entre 3 e 100 caracteres';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: TextFormField(
                              style: Theme.of(context).textTheme.bodyLarge,
                              controller: _notaController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
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
                                    double.parse(value) <= 0) {
                                  return 'Nota deve ser um número maior que 0';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_form.currentState!.validate()) {
                                  if (widget.questao.id == -1) {
                                    questaoService
                                        .criarQuestao(
                                            context,
                                            Questao(
                                                id: -1,
                                                tipo: widget.questao.tipo,
                                                nome: _nomeController.text,
                                                nota: double.parse(
                                                    _notaController.text),
                                                enunciado:
                                                    _enunciadoController.text),
                                            widget.atividade)
                                        .then((resposta) {
                                      if (resposta.isSucess()) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  } else {
                                    questaoService
                                        .editarQuestao(
                                            context,
                                            Questao(
                                                id: widget.questao.id,
                                                tipo: widget.questao.tipo,
                                                nome: _nomeController.text,
                                                nota: double.parse(
                                                    _notaController.text),
                                                enunciado:
                                                    _enunciadoController.text),
                                            widget.atividade.id)
                                        .then((resposta) {
                                      if (resposta.isSucess()) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
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
                                widget.questao.id == -1
                                    ? 'Criar questão'
                                    : 'Salvar alterações',
                                style: TextStyle(
                                  fontSize: 16,
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
                    const SizedBox(height: 40.0),
                    if (widget.questao.tipo == 2 ?? true)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Gerenciar questões',
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
        ],
      ),
    );
  }
}
