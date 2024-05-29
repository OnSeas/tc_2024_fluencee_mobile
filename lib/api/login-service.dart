import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/interceptor/dio-interceptor.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';

import '../alertas/alertas.dart';
import '../models/Login.dart';

class LoginService {
  final Alertas alerta = Alertas();

  late Dio dio;

  LoginService() {
    dio = Dio(BaseOptions(
      baseUrl: ApiService.apiUrl,
      validateStatus: (status) {
        return true;
      },
    ));
    dio.interceptors.add(DioInterceptor());
  }

  // Cadastrar
  Future<void> cadastrar(context, Usuario usuario) async {
    // TODO
  }

  // Login
  Future<bool> login(context, Login login) async {
    Map<String, dynamic> data = {
      'login': login.login,
      'senha': login.senha,
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.post("/login", data: data);

      if (res.statusCode == 200) {
        final String token = res.data['token'];
        ApiService.setTokenUsuario(token);

        await alerta.messageAlertDialog(
            context, "Bem-vindo", "Login efetuado com sucesso!");
      } else {
        print("Erro ao realizar login - status: ${res.statusCode}");
        await alerta.messageAlertDialog(context, "Essa não!",
            "Não foi possível realizar o login, parece que nosso sistema não está funcionando no momento, desculpe.");
        throw Exception('Erro ao realizar login: ${res.data}');
      }
      return true;
    } on DioException catch (e) {
      print('Dio error: $e');
      if (e.response != null) {
        print('Dio error response: ${e.response?.data}');
      }
      await alerta.messageAlertDialog(context, "Erro", "${e.response?.data}");
      return false;
    } catch (e) {
      print('Other error: $e');
      await alerta.messageAlertDialog(context, "Erro",
          "Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde!");
      return false;
    }
  }
}
