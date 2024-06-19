import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // apiUrl geral
  static const apiUrl =
      'http://0.0.0.0:8080/fluencee'; // MUDAR 0.0.0.0 PARA IPV4 DE SUA REDE SE FOR UTILIZAR

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
