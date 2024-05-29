import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/login-service.dart';
import 'package:tc_2024_fluencee_mobile/api/usuario-service.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';

import '../routes/app-routes.dart';

final UsuarioService usuarioService = UsuarioService();
final LoginService loginService = LoginService();

class TelaTurmas extends StatefulWidget {
  const TelaTurmas({Key? key}) : super(key: key);

  @override
  _TelaTurmasState createState() => _TelaTurmasState();
}

class _TelaTurmasState extends State<TelaTurmas> {
  Future<Usuario>? _usuarioFuture;

  @override
  void initState() {
    super.initState();
    _usuarioFuture = usuarioService.buscarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario>(
      future: _usuarioFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar usuário: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).canvasColor,
              titleSpacing: 0,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'perfil') {
                      Navigator.pushNamed(context, AppRoutes.TELA_PERFIL);
                    } else if (value == 'sair') {}
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
                        snapshot.data!.nome,
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
          );
        } else {
          return Text('Nenhum dado de usuário disponível.');
        }
      },
    );
  }
}
