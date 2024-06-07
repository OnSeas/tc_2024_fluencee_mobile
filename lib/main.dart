import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/pages/tela-login.dart';
import 'package:tc_2024_fluencee_mobile/pages/tela-listar-turmas.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';

import 'pages/tela-cadastro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const double appBarHeight = 0.08;

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
          titleSmall: TextStyle(
            fontSize: 22,
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
      },
    );
  }
}
