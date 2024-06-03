import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/login-service.dart';

import '../models/Usuario.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final LoginService loginService = LoginService();
  final _form = GlobalKey<FormState>();

  bool _showPassword = false;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Stack(
        children: [
          // Fundo com logo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Center(
                child: Image.asset(
                  'assets/imgs/Logo_fundo_escuro.png',
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ),
            ),
          ),

          //Seta de volta
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Theme.of(context).scaffoldBackgroundColor,
              onPressed: () {
                Navigator.pop(context); // Voltar para a tela anterior
              },
            ),
          ),

          // Fundo com caixas de texto e botões
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bem-vindo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Preencha os dados abaixo para criar sua conta.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 20),

                      //Form
                      Form(
                        key: _form,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
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
                                    } else if (_nomeController.text.length <
                                            3 ||
                                        _nomeController.text.length > 200) {
                                      return 'O nome deve ter entre 3 e 200 caracteres!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
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
                                    } else if (_emailController.text.length >
                                        256) {
                                      return 'O nome deve ter entre 3 e 200 caracteres!';
                                    } else if (!_emailController.text
                                            .contains("@") ||
                                        !_emailController.text.contains(".") ||
                                        _emailController.text.indexOf("@") >
                                            _emailController.text
                                                .indexOf(".")) {
                                      return 'O email deve seguir o padrão email@email.com!';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  controller: _confirmEmailController,
                                  decoration: InputDecoration(
                                    labelText: 'Confirmar email *',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor preencha o campo Confirmar email!';
                                    } else if (!(_emailController.text ==
                                        _confirmEmailController.text)) {
                                      return 'Os emails não são iguais!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  controller: _confirmSenhaController,
                                  obscureText: !_showPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Confirmar senha *',
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
                                      return 'Por favor preencha o campo Confirmar senha!';
                                    } else if (!(_senhaController.text ==
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
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_form.currentState!.validate()) {
                                      _form.currentState!.save();
                                      loginService
                                          .cadastrar(
                                              context,
                                              Usuario(
                                                idUsuario: 0,
                                                nome: _nomeController.text,
                                                email: _emailController.text,
                                                senha: _senhaController.text,
                                              ))
                                          .then((value) {
                                        if (value == true) {
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
                                    'Cadastrar-se',
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
        ],
      ),
    );
  }
}
