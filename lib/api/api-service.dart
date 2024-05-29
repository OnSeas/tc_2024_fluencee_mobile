import 'package:shared_preferences/shared_preferences.dart';
import 'package:tc_2024_fluencee_mobile/api/usuario-service.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';
import 'package:tc_2024_fluencee_mobile/pages/tela3-listar-turmas.dart';

class ApiService {
  // apiUrl geral
  static const apiUrl =
      'http://192.168.3.8:8080/fluencee'; // Lembrar de sempre alterar o IP

  static const String tokenKey = "LOGINTOKEN";

  static Future<String?> getTokenUsuarioLogado() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString(tokenKey);

    if (token != null) {
      return token;
    } else {
      return null;
    }
  }

  static void setTokenUsuario(String token) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setString(tokenKey, token);
  }
}
