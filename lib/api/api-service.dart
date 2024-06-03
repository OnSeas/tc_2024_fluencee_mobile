import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<void> deslogarUsuario() async {
    setTokenUsuario("");
  }
}
