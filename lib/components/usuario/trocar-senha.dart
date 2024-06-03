import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/api/usuario-service.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';

class TelaTrocarSenha extends StatefulWidget {
  const TelaTrocarSenha({super.key});

  @override
  State<TelaTrocarSenha> createState() => _TelaTrocarSenhaState();
}

class _TelaTrocarSenhaState extends State<TelaTrocarSenha> {
  final _form = GlobalKey<FormState>();

  bool _showPassword = false;
  bool _showNewPassword = false;

  final _senhaAntigaController = TextEditingController();
  final _senhaNovaController = TextEditingController();
  final _confirmSenhaController = TextEditingController();

  final UsuarioService usuarioService = UsuarioService();

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
          height: MediaQuery.of(context).size.height * 0.1,
          color: Theme.of(context).canvasColor,
          child: ListTile(
            title: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    // Ação ao pressionar o nome do usuário
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Osmar', // TODO mudar para colocar o do usuário logado
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

      // Fundo com caixas de texto e botões
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
                    'Olá!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Para redefinir sua senha preencha os dados abaixo.',
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
                              controller: _senhaAntigaController,
                              obscureText: !_showPassword,
                              decoration: InputDecoration(
                                labelText: 'Senha Antiga*',
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
                                  return 'Por favor preencha o campo Email!';
                                } else if (value.length < 8 ||
                                    value.length > 35) {
                                  return 'A senha deve ter entre 8 e 35 caracteres!';
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
                              controller: _senhaNovaController,
                              obscureText: !_showNewPassword,
                              decoration: InputDecoration(
                                labelText: 'Nova senha *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showNewPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showNewPassword = !_showNewPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor preencha o campo Senha!';
                                } else if (value.length < 8 ||
                                    value.length > 35) {
                                  return 'A senha deve ter entre 8 e 35 caracteres!';
                                } else if (!RegExp(
                                        r"^(?=.*[a-zA-Z])(?=.*\d).*$")
                                    .hasMatch(value)) {
                                  return 'A senha deve ter no mínimo 1 letra e 1 número!';
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
                              controller: _confirmSenhaController,
                              obscureText: !_showNewPassword,
                              decoration: InputDecoration(
                                labelText: 'Confirmar nova senha *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showNewPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showNewPassword = !_showNewPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor preencha o campo Confirmar senha!';
                                } else if (!(_senhaNovaController.text ==
                                    value)) {
                                  return 'As senhas não são iguais!';
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
                                  usuarioService.TrocarSenha(
                                          context,
                                          _senhaAntigaController.text,
                                          _senhaNovaController.text)
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
                                'Trocar de senha',
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
