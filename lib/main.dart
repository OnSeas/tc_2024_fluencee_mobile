import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/pages/tela1-login.dart';
import 'package:tc_2024_fluencee_mobile/pages/tela3-listar-turmas.dart';
import 'package:tc_2024_fluencee_mobile/pages/tela4-perfil.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';

import 'pages/tela2-cadastro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluencee',
      theme: ThemeData(
        // Cores e Fontes pré-definidas nos protótipos

        colorScheme: const ColorScheme.light(
          primary: Color(0xFF5557FF),
          secondary: Color(0xFF3CE021),
          error: Color(0xFFEB0707),
        ),
        scaffoldBackgroundColor: const Color(0xFFEEEEEE),
        canvasColor: const Color(0xFF131313),

        appBarTheme: const AppBarTheme(
          color: Color(0xFF131313), // Cor da AppBar
        ),

        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 40,
            //fontWeight: FontWeight.bold,
            fontFamily: 'Alata',
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontFamily: 'Assistant',
          ),
        ),
      ),
      home: const TelaLogin(),
      routes: {
        AppRoutes.TELA_LOGIN: (context) => const TelaLogin(),
        AppRoutes.TELA_CADASTRO: (context) => const TelaCadastro(),
        AppRoutes.TELA_TURMAS: (context) => const TelaTurmas(),
        // AppRoutes.TELA_PERFIL: (context) => const TelaPerfil(),
        //AppRoutes.TELA_TROCAR_SENHA: (context) => const TelaTrocarSenha(),
        //AppRoutes.TELA_EXCLUIR_CONTA: (context) => const TelaExcluirConta(),
      },
    );
  }
}
