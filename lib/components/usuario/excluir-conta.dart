import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/api/usuario-service.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';

class TelaExcluirConta extends StatefulWidget {
  final Usuario usuario;

  const TelaExcluirConta({Key? key, required this.usuario}) : super(key: key);

  @override
  State<TelaExcluirConta> createState() => _TelaExcluirContaState();
}

class _TelaExcluirContaState extends State<TelaExcluirConta> {
  final _form = GlobalKey<FormState>();
  final UsuarioService usuarioService = UsuarioService();

  bool _showPassword = false;

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  late Usuario _currentUser;

  @override
  void initState() {
    _currentUser = widget.usuario;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // App bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * MyApp.appBarHeight,
            color: Theme.of(context).canvasColor,
            child: ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Excluir conta',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              fontSize: 20,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Seta de volta
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
                      'Tem certeza?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'A exclusão de conta não pode ser desfeita e não será possível criar outra conta com o mesmo email.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                    Text(
                      'Preencha os dados abaixo: ',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

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
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email *',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor preencha o campo Email!';
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
                                controller: _senhaController,
                                obscureText: !_showPassword,
                                decoration: InputDecoration(
                                  labelText: 'Senha *',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor preencha o campo Senha!';
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
                                    deleteAlertDialog(
                                        context,
                                        Usuario(
                                            idUsuario: _currentUser.idUsuario,
                                            nome: _currentUser.nome,
                                            email: _emailController.text,
                                            senha: _senhaController.text));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  'Excluir conta',
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
      ]),
    );
  }

  deleteAlertDialog(BuildContext context, Usuario usuario) {
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
        usuarioService.excluirConta(context, usuario).then((resposta) => {
              if (resposta.isSucess() || resposta.isFatalError())
                {
                  ApiService.deslogarUsuario().then((value) =>
                      Navigator.popAndPushNamed(context, AppRoutes.TELA_LOGIN))
                }
              else
                {Navigator.pop(context)}
            });
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
              "Excluir conta",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10.0),
            Text(
              "Você deseja excluir sua conta?",
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
