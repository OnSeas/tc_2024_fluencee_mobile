import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tc_2024_fluencee_mobile/alertas/alertas.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/interceptor/dio-interceptor.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';

class UsuarioService {
  final Alertas alerta = Alertas();

  late Dio dio;

  UsuarioService() {
    dio = Dio(BaseOptions(
      baseUrl: '${ApiService.apiUrl}/usuario',
      validateStatus: (status) {
        return true;
      },
    ));
    dio.interceptors.add(DioInterceptor());
  }

  // Buscar informações do usuário logado
  Future<Usuario> buscarUsuario() async {
    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.get("/info");

      if (res.statusCode == 200) {
        Usuario usuario = Usuario(
            idUsuario: res.data["idUsuario"],
            nome: res.data["nome"],
            email: res.data["email"]);
        return usuario;
      } else {
        print("Erro ao buscar o usuário - status: ${res.statusCode}");
        throw Exception("Erro ao buscar o usuário");
      }
    } catch (e) {
      print('rror: $e');
      return Usuario(
          idUsuario: -1,
          nome: "nome",
          email: "email"); // TODO generico de erro que volta para o login.
    }
  }
}
