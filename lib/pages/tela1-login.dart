import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/login-service.dart';
import 'package:tc_2024_fluencee_mobile/models/Login.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final LoginService loginService = LoginService();

  final _form = GlobalKey<FormState>();

  bool _showPassword = false;

  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

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
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: Image.asset(
                  'assets/imgs/Logo_com_nome_fundo_escuro.png',
                  height: MediaQuery.of(context).size.height * 0.17,
                ),
              ),
            ),
          ),

          // Fundo com caixas de texto e botões
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
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
                        'Entre suas informações abaixo.',
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
                                  controller: _loginController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
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
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  obscureText: !_showPassword,
                                  controller: _senhaController,
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
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
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_form.currentState!.validate()) {
                                      _form.currentState!.save();
                                      loginService
                                          .login(
                                              context,
                                              Login(
                                                login: _loginController.text,
                                                senha: _senhaController.text,
                                              ))
                                          .then((value) => {
                                                if (value == true)
                                                  {
                                                    Navigator.pushNamed(context,
                                                        AppRoutes.TELA_TURMAS)
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
                                    'Realizar Login',
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
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          // Colocar para ir para a tela de redefinir a senha por email.
                        },
                        child: Text(
                          'Esqueceu sua senha?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .fontFamily,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppRoutes.TELA_CADASTRO);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Cadastre-se',
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
            ),
          ),
        ],
      ),
    );
  }
}
