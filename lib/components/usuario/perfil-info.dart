import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/api/usuario-service.dart';
import 'package:tc_2024_fluencee_mobile/components/usuario/excluir-conta.dart';
import 'package:tc_2024_fluencee_mobile/components/usuario/trocar-senha.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';

class PerfilInfo extends StatefulWidget {
  final Usuario usuario;

  const PerfilInfo({Key? key, required this.usuario}) : super(key: key);

  @override
  State<PerfilInfo> createState() => _PerfilInfoState();
}

class _PerfilInfoState extends State<PerfilInfo> {
  UsuarioService usuarioService = UsuarioService();
  final _formKey = GlobalKey<FormState>();

  bool isEditing = false;
  late TextEditingController _nomeController;
  late Usuario _currentUser;

  @override
  void initState() {
    _nomeController = TextEditingController(text: widget.usuario.nome);
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
                      _currentUser.nome,
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

      //Conteudo
      Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
              child: Container(
            child: Column(children: [
              Text(
                'Olá, ${_currentUser.nome}!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                'O que deseja editar hoje?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              // Parte de edição
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Nome',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: TextFormField(
                                controller: _nomeController,
                                enabled: isEditing,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 16.0,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor preencha o campo Nome!';
                                  } else if (_nomeController.text.length < 3 ||
                                      _nomeController.text.length > 200) {
                                    return 'O nome deve ter entre 3 e 200 caracteres!';
                                  }
                                  return null;
                                }),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isEditing == true) {
                            if (_formKey.currentState!.validate()) {
                              usuarioService
                                  .editarNome(
                                      context,
                                      Usuario(
                                          idUsuario: _currentUser.idUsuario,
                                          nome: _nomeController.text,
                                          email: _currentUser.email))
                                  .then((resposta) {
                                if (resposta.isSucess()) {
                                  _atualizarUsuario(resposta.object as Usuario);
                                  setState(() {
                                    isEditing = !isEditing;
                                  });
                                } else if (resposta.isFatalError()) {
                                  ApiService.deslogarUsuario().then((value) =>
                                      Navigator.popAndPushNamed(
                                          context, AppRoutes.TELA_LOGIN));
                                }
                              });
                            }
                          } else {
                            setState(() {
                              isEditing = !isEditing;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEditing
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          isEditing ? 'Salvar' : 'Editar',
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

              const SizedBox(height: 16.0),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListTile(
                  title: Text(
                    "Email",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    widget.usuario.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 22),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.24),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TelaTrocarSenha()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Trocar senha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.bodyLarge!.fontFamily,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TelaExcluirConta(usuario: _currentUser)));
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
                        'Excluir conta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.bodyLarge!.fontFamily,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ]),
          )))
    ]));
  }

  // Atualizar o usuário depois de alterar
  void _atualizarUsuario(Usuario novoUsuario) {
    setState(() {
      _currentUser = novoUsuario;
    });
  }
}
