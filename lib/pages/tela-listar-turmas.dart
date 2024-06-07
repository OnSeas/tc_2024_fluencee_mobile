import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/alertas/snackbar.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/api/login-service.dart';
import 'package:tc_2024_fluencee_mobile/api/turmas-service.dart';
import 'package:tc_2024_fluencee_mobile/api/usuario-service.dart';
import 'package:tc_2024_fluencee_mobile/components/turmas/criar-editar-turma.dart';
import 'package:tc_2024_fluencee_mobile/components/usuario/perfil-info.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';
import 'package:tc_2024_fluencee_mobile/pages/tela-login.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';

final UsuarioService usuarioService = UsuarioService();
final LoginService loginService = LoginService();

class TelaTurmas extends StatefulWidget {
  const TelaTurmas({Key? key}) : super(key: key);

  @override
  _TelaTurmasState createState() => _TelaTurmasState();
}

class _TelaTurmasState extends State<TelaTurmas> {
  TurmasService turmasService = TurmasService();

  late Future<Usuario> _usuarioFuture;
  late Future<List<Turma>> _listaTurmasUsuario;

  @override
  void initState() {
    super.initState();
    _usuarioFuture = usuarioService.buscarUsuario();
    _listaTurmasUsuario = _carregarTurmas();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario>(
      future: _usuarioFuture,
      builder: (context, usuarioSnapshot) {
        if (usuarioSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (usuarioSnapshot.hasError) {
          CustomSnackBar(
                  context: context,
                  message:
                      "Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde",
                  isError: true)
              .show();
          ApiService.deslogarUsuario().then((value) =>
              Navigator.popAndPushNamed(context, AppRoutes.TELA_LOGIN));
          return Center(
              child:
                  Text('Erro ao carregar usuário: ${usuarioSnapshot.error}'));
        } else if (usuarioSnapshot.hasData) {
          return Scaffold(
            // appbar
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).canvasColor,
              titleSpacing: 0,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'perfil') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PerfilInfo(usuario: usuarioSnapshot.data!),
                          )).then((value) => _atualizarUsuario());
                    } else if (value == 'sair') {
                      ApiService.deslogarUsuario().then((value) =>
                          Navigator.popAndPushNamed(
                              context, AppRoutes.TELA_LOGIN));
                      CustomSnackBar(
                              context: context,
                              message: "Você saiu da sua conta!",
                              isError: false)
                          .show();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'perfil',
                      child: Text('Perfil'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'sair',
                      child: Text('Sair'),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        usuarioSnapshot.data!.nome,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Corpo da página
            body: RefreshIndicator(
              onRefresh: _atualizarListaTurmas,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bem-vindo',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Abaixo se encontram as turmas que você faz parte.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: FutureBuilder<List<Turma>>(
                        future: _listaTurmasUsuario,
                        builder: (context, turmasSnapshot) {
                          if (turmasSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (turmasSnapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Erro ao carregar turmas: ${turmasSnapshot.error}'));
                          }
                          if (turmasSnapshot.hasData &&
                              turmasSnapshot.data!.isEmpty) {
                            // Lista de turmas vazia
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/imgs/Lista_Vazia.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Parece que você ainda não faz parte de nenhuma Turma.',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }

                          return ListView.builder(
                            itemCount: turmasSnapshot.data!.length,
                            itemBuilder: ((context, i) => ListTile(
                                  title: Text(
                                      turmasSnapshot.data!.elementAt(i).nome!),
                                  // TODO construir o tile de turma
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Botão nova turma
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                novaTurmaDialog(context);
              },
              child: Icon(
                Icons.add,
                size: 32,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          );
        } else {
          CustomSnackBar(
                  context: context,
                  message:
                      "Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde",
                  isError: true)
              .show();
          ApiService.deslogarUsuario().then((value) =>
              Navigator.popAndPushNamed(context, AppRoutes.TELA_LOGIN));
          return Center(
              child:
                  Text('Erro ao carregar usuário: ${usuarioSnapshot.error}'));
        }
      },
    );
  }

  novaTurmaDialog(BuildContext context) {
    // botões
    Widget criarTurmaButton = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
        ),
        child: Text(
          "Criar turma",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color:
                    Theme.of(context).scaffoldBackgroundColor, // Cor do texto
              ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditarTurma(
                  turma: Turma(id: -1),
                ),
              )).then((value) {
            _atualizarListaTurmas();
            Navigator.pop(context);
          });
        },
      ),
    );

    Widget entrarTurmaButton = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
        ),
        child: Text(
          "Entrar em turma",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
        ),
        onPressed: () {
          entrarTurmaDialog(context);
        },
      ),
    );

    Widget cancelarButton = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
        ),
        child: Text(
          "Cancelar",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
              "Nova turma",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10.0),
            Text(
              "Selecione uma opção",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      actions: [
        criarTurmaButton,
        SizedBox(height: 10.0),
        entrarTurmaButton,
        SizedBox(height: 10.0),
        cancelarButton
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void entrarTurmaDialog(BuildContext context) {
    TextEditingController codeController = TextEditingController();

    Widget entrarTurmaButton = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Text(
          "Entrar na turma",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color:
                    Theme.of(context).scaffoldBackgroundColor, // Cor do texto
              ),
        ),
        onPressed: () {
          turmasService.entrarTurma(context, codeController.text).then((value) {
            _atualizarListaTurmas();
            Navigator.pop(context);
            Navigator.pop(context);
          });
        },
      ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Digite o código da turma",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: codeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelText: 'Código da turma',
                ),
              ),
            ),
            SizedBox(height: 10.0),
            entrarTurmaButton,
          ],
        ),
      ),
    );

    // Para aparecer o modal.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _atualizarUsuario() {
    setState(() {
      _usuarioFuture = usuarioService.buscarUsuario();
    });
  }

  Future<void> _atualizarListaTurmas() async {
    setState(() {
      _listaTurmasUsuario = _carregarTurmas();
    });
  }

  Future<List<Turma>> _carregarTurmas() async {
    final resposta = await turmasService.ListarTurmas(context);
    if (resposta.isSucess()) {
      return resposta.object as List<Turma>;
    } else if (resposta.isFatalError()) {
      await ApiService.deslogarUsuario();
      Navigator.popAndPushNamed(context, AppRoutes.TELA_LOGIN);
    }
    return [];
  }
}
