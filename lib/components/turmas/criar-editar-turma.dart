import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/api/turmas-service.dart';
import 'package:tc_2024_fluencee_mobile/components/turmas/gerenciar-inscricoes.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';

class EditarTurma extends StatefulWidget {
  final Turma turma;

  const EditarTurma({Key? key, required this.turma}) : super(key: key);

  @override
  State<EditarTurma> createState() => _EditarTurmaState();
}

class _EditarTurmaState extends State<EditarTurma> {
  final TurmasService turmasService = TurmasService();
  final _form = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _anoController = TextEditingController();
  final _salaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.turma.id != -1) _nomeController.text = widget.turma.nome!;
    if (widget.turma.id != -1 && widget.turma.sala != null)
      _salaController.text = widget.turma.sala!;
    if (widget.turma.id != -1 && widget.turma.ano != null)
      _anoController.text = widget.turma.ano!;
  }

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
                    widget.turma.id == -1 ? 'Criar Turma' : "Editar Turma",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    'Preencha os dados da turma abaixo: ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  //Form
                  Form(
                    key: _form,
                    child: SingleChildScrollView(
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
                                  return 'Nome da turma deve ter entre 4 e 40 caracteres';
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
                              controller: _anoController,
                              decoration: InputDecoration(
                                labelText: 'Ano',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (value.length > 40) {
                                    return 'Ano deve ter menos que 40 caracteres';
                                  }
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
                              controller: _salaController,
                              decoration: InputDecoration(
                                labelText: 'Sala',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (value.length > 40) {
                                    return 'Sala deve ter menos que 40 caracteres';
                                  }
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
                                  _form.currentState!.save();
                                  if (widget.turma.id == -1) {
                                    turmasService
                                        .cadastrar(
                                            context,
                                            Turma(
                                                id: -1,
                                                nome: _nomeController.text,
                                                ano: _anoController.text,
                                                sala: _salaController.text))
                                        .then((resposta) => {
                                              if (resposta.isSucess())
                                                {Navigator.pop(context)}
                                              else if (resposta.isFatalError())
                                                {
                                                  ApiService.deslogarUsuario()
                                                      .then((value) => Navigator
                                                          .popAndPushNamed(
                                                              context,
                                                              AppRoutes
                                                                  .TELA_LOGIN))
                                                }
                                            });
                                  } else {
                                    turmasService
                                        .editarTurma(
                                            context,
                                            Turma(
                                                id: widget.turma.id,
                                                nome: _nomeController.text,
                                                ano: _anoController.text,
                                                sala: _salaController.text))
                                        .then((resposta) => {
                                              if (resposta.isSucess())
                                                {Navigator.pop(context)}
                                              else if (resposta.isFatalError())
                                                {
                                                  ApiService.deslogarUsuario()
                                                      .then((value) => Navigator
                                                          .popAndPushNamed(
                                                              context,
                                                              AppRoutes
                                                                  .TELA_LOGIN))
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
                                widget.turma.id == -1
                                    ? 'Criar turma'
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
                  ),
                  const SizedBox(height: 40.0),
                  if (widget.turma.id != -1)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TelaGerenciarInscricoes(
                                      turma: widget.turma)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Gerenciar inscrições',
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
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        deleteAlertDialog(context, widget.turma);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Text(
                        'Excluir Turma',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.bodyLarge!.fontFamily,
                          color: Theme.of(context).colorScheme.error,
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

  deleteAlertDialog(BuildContext context, Turma turma) {
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
        turmasService.excluirTurma(context, turma).then((resposta) {
          if (resposta.isFatalError()) {
            ApiService.deslogarUsuario().then((value) =>
                Navigator.popAndPushNamed(context, AppRoutes.TELA_LOGIN));
          } else if (resposta.isSucess()) {
            Navigator.popAndPushNamed(context, AppRoutes.TELA_TURMAS);
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
              "Excluir Turma",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10.0),
            Text(
              "Você deseja excluir esta turma?",
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
