import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tc_2024_fluencee_mobile/api/atividades-service.dart';
import 'package:tc_2024_fluencee_mobile/components/questoes/listar-questoes-editar.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';

class EditarAtividade extends StatefulWidget {
  final Turma turma;
  final Atividade atividade;

  const EditarAtividade(
      {super.key, required this.turma, required this.atividade});

  @override
  State<EditarAtividade> createState() => _EditarAtividadeState();
}

class _EditarAtividadeState extends State<EditarAtividade> {
  AtividadeService atividadeService = AtividadeService();

  final _form = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _notaController = TextEditingController();
  final _enunciadoController = TextEditingController();

  int? _tipoAtividade;

  @override
  void initState() {
    if (widget.atividade.id != -1) {
      _nomeController.text = widget.atividade.nome!;
      _enunciadoController.text = widget.atividade.enunciado!;
      _notaController.text = widget.atividade.notaValor!.toString();
      _tipoAtividade = widget.atividade.tipoAtividade;
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
                      widget.atividade.id == -1
                          ? 'Criar Atividade'
                          : "Editar Atividade",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      'Preencha os dados da atividade abaixo: ',
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
                                } else if (value.length < 4 ||
                                    value.length > 40) {
                                  return 'Nome da atividade deve ter entre 4 e 40 caracteres';
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
                            height: MediaQuery.of(context).size.height * 0.16,
                            child: TextFormField(
                              style: Theme.of(context).textTheme.bodyLarge,
                              controller: _enunciadoController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: 'Orientação',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isNotEmpty && value.length > 500) {
                                  return 'Orientação deve ter menos que 500 caracteres';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                child: DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Tipo de Atividade *',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  value: _tipoAtividade,
                                  items: [
                                    DropdownMenuItem(
                                      value: 1,
                                      child: Text('Individual'),
                                    ),
                                    DropdownMenuItem(
                                      value: 2,
                                      child: Text('Dupla'),
                                    ),
                                    DropdownMenuItem(
                                      value: 3,
                                      child: Text('Grupo'),
                                    ),
                                  ],
                                  onChanged: widget.atividade.id != -1
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _tipoAtividade = value;
                                          });
                                        },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Por favor selecione um tipo de atividade!';
                                    }
                                    return null;
                                  },
                                )),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_form.currentState!.validate()) {
                                  if (widget.atividade.id == -1) {
                                    atividadeService
                                        .cadastrar(
                                            context,
                                            Atividade(
                                                id: -1,
                                                nome: _nomeController.text,
                                                notaValor: double.parse(
                                                    _notaController.text),
                                                enunciado:
                                                    _enunciadoController.text,
                                                tipoAtividade: _tipoAtividade),
                                            widget.turma)
                                        .then((resposta) {
                                      if (resposta.isSucess()) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  } else {
                                    atividadeService
                                        .editarAtividade(
                                            context,
                                            Atividade(
                                                id: widget.atividade.id,
                                                nome: _nomeController.text,
                                                notaValor: double.parse(
                                                    _notaController.text),
                                                enunciado:
                                                    _enunciadoController.text))
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
                                widget.atividade.id == -1
                                    ? 'Criar atividade'
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
                    if (widget.atividade.id != -1 ?? true)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListaQuestoes(
                                      atividade: widget.atividade)),
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
                    const SizedBox(height: 10.0),
                    if (widget.atividade.id != -1 ?? true)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            deleteAlertDialog(context, widget.atividade);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Excluir atividade',
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
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  deleteAlertDialog(BuildContext context, Atividade atividade) {
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
        "Deletar",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onPressed: () {
        atividadeService
            .excluirAtividade(context, widget.atividade)
            .then((resposta) {
          if (resposta.isSucess()) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        });
      },
    );

    // O dialogo
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Excluir Atividade",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10.0),
            Text(
              "Você deseja excluir esta atividade?",
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
