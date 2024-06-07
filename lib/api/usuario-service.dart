import 'package:dio/dio.dart';
import 'package:tc_2024_fluencee_mobile/alertas/snackbar.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/interceptor/dio-interceptor.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';
import 'package:tc_2024_fluencee_mobile/utils/resposta.dart';

class UsuarioService {
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
      return Usuario(idUsuario: -1, nome: "nome", email: "email");
    }
  }

  // Editar nome
  Future<Resposta> editarNome(context, Usuario usuario) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'nome': usuario.nome,
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.put("/alterarNome", data: data);

      if (res.statusCode == 200) {
        Usuario usuario = Usuario(
            idUsuario: res.data["idUsuario"],
            nome: res.data["nome"],
            email: res.data["email"]);

        CustomSnackBar(
                context: context,
                message: "Nome alterado com sucesso!",
                isError: false)
            .show();

        resposta.object = usuario;
        resposta.resultado = Resposta.SUCESS;
        return resposta;
      } else if (res.statusCode == 400 || res.statusCode == 404) {
        CustomSnackBar(context: context, message: res.data, isError: true)
            .show();

        resposta.resultado = Resposta.ERROR;
        return resposta;
      } else {
        throw Exception("Erro ao alterar nome.");
      }
    } catch (e) {
      print('error: $e');
      CustomSnackBar(
              context: context,
              message:
                  "Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde",
              isError: true)
          .show();
      resposta.resultado = Resposta.FATAL_ERROR;
      return resposta;
    }
  }

  // Trocar senha
  Future<Resposta> TrocarSenha(
      context, String senhaAntiga, String senhaNova) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'senhaAntiga': senhaAntiga,
      'senhaNova': senhaNova
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.put("/trocarSenha", data: data);

      if (res.statusCode == 200) {
        Usuario usuario = Usuario(
            idUsuario: res.data["idUsuario"],
            nome: res.data["nome"],
            email: res.data["email"]);

        CustomSnackBar(
                context: context,
                message: "Senha alterada com sucesso!",
                isError: false)
            .show();

        resposta.object = usuario;
        resposta.resultado = Resposta.SUCESS;
        return resposta;
      } else if (res.statusCode == 400 || res.statusCode == 404) {
        CustomSnackBar(context: context, message: res.data, isError: true)
            .show();

        resposta.resultado = Resposta.ERROR;
        return resposta;
      } else {
        throw Exception("Erro alterar senha.");
      }
    } catch (e) {
      print('error: $e');
      CustomSnackBar(
              context: context,
              message:
                  "Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde",
              isError: true)
          .show();
      resposta.resultado = Resposta.FATAL_ERROR;
      return resposta;
    }
  }

  // Excluir Conta
  Future<Resposta> excluirConta(context, Usuario usuario) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'nome': usuario.nome,
      'email': usuario.email,
      'senha': usuario.senha,
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.put("/desativar", data: data);

      if (res.statusCode == 200) {
        Usuario usuario = Usuario(
            idUsuario: res.data["idUsuario"],
            nome: res.data["nome"],
            email: res.data["email"]);

        CustomSnackBar(
                context: context,
                message: "Perfil excluído com sucesso!",
                isError: false)
            .show();

        resposta.object = usuario;
        resposta.resultado = Resposta.SUCESS;
        return resposta;
      } else if (res.statusCode == 400 || res.statusCode == 404) {
        CustomSnackBar(context: context, message: res.data, isError: true)
            .show();

        resposta.resultado = Resposta.ERROR;
        return resposta;
      } else {
        throw Exception("Erro excluir conta.");
      }
    } catch (e) {
      print('error: $e');
      CustomSnackBar(
              context: context,
              message:
                  "Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde",
              isError: true)
          .show();
      resposta.resultado = Resposta.FATAL_ERROR;
      return resposta;
    }
  }
}
