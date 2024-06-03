import 'package:dio/dio.dart';
import 'package:tc_2024_fluencee_mobile/alertas/snackbar.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/interceptor/dio-interceptor.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';

import '../models/Login.dart';

class LoginService {
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
  Future<bool> cadastrar(context, Usuario usuario) async {
    Map<String, dynamic> data = {
      'nome': usuario.nome,
      'email': usuario.email,
      'senha': usuario.senha
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.post("/cadastrar", data: data);

      if (res.statusCode == 200) {
        CustomSnackBar(
                context: context,
                message: "Cadastro efetuado com sucesso!",
                isError: false)
            .show();
        return true;
      } else if (res.statusCode == 400 || res.statusCode == 404) {
        CustomSnackBar(context: context, message: res.data, isError: true)
            .show();
        return false;
      } else {
        throw Exception(
            'Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde!');
      }
    } catch (e) {
      print('Erro na solicitação: $e');
      CustomSnackBar(
              context: context,
              message:
                  'Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde!',
              isError: true)
          .show();
      return false;
    }
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

        CustomSnackBar(
                context: context,
                message: "Login realizado com sucesso",
                isError: false)
            .show();
        return true;
      } else if (res.statusCode == 400 || res.statusCode == 404) {
        CustomSnackBar(context: context, message: res.data, isError: true)
            .show();
        return false;
      } else if (res.statusCode == 403) {
        CustomSnackBar(
                context: context,
                message: "Login incorreto, por favor tente novamente!",
                isError: true)
            .show();
        return false;
      } else {
        throw Exception(
            'Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde!');
      }
    } catch (e) {
      print('Erro na solicitação: $e');
      CustomSnackBar(
              context: context,
              message:
                  'Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde!',
              isError: true)
          .show();
      return false;
    }
  }
}
