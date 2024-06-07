import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/api/turmas-service.dart';
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
                    'Criar Turma',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    'Preencha os dados abaixo para criar sua turma: ',
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
                                'Criar turma',
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
                ],
              ),
            ),
          ),
        ),
      ),
    ]));
  }
}
