import 'package:dio/dio.dart';
import 'package:tc_2024_fluencee_mobile/alertas/snackbar.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/interceptor/dio-interceptor.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';
import 'package:tc_2024_fluencee_mobile/utils/resposta.dart';

class TurmasService {
  late Dio dio;

  TurmasService() {
    dio = Dio(BaseOptions(
      baseUrl: '${ApiService.apiUrl}/turma',
      validateStatus: (status) {
        return true;
      },
    ));
    dio.interceptors.add(DioInterceptor());
  }

  // Criar turmas
  Future<Resposta> cadastrar(context, Turma turma) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'nome': turma.nome,
      if (turma.ano != null) 'ano': turma.ano,
      if (turma.sala != null) 'sala': turma.sala
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.post("/criar", data: data);

      if (res.statusCode == 200) {
        CustomSnackBar(
                context: context,
                message: "Turma criada com sucesso!",
                isError: false)
            .show();

        resposta.resultado = Resposta.SUCESS;
        resposta.object = Turma(id: res.data['id'], nome: res.data['nome']);
        return resposta;
      } else if (res.statusCode == 400 || res.statusCode == 404) {
        CustomSnackBar(context: context, message: res.data, isError: true)
            .show();

        resposta.resultado = Resposta.ERROR;
        return resposta;
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
      resposta.resultado = Resposta.FATAL_ERROR;
      return resposta;
    }
  }

  // Listar turmas do usuário
  Future<Resposta> ListarTurmas(context) async {
    Resposta resposta = Resposta();

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.get("/listar");

      if (res.statusCode == 200) {
        List<dynamic> dataList = res.data;
        List<Turma> turmasUsuario = Turma.fromJsonList(dataList);

        resposta.object = turmasUsuario;
        resposta.resultado = Resposta.SUCESS;
        return resposta;
      } else if (res.statusCode == 400 || res.statusCode == 404) {
        CustomSnackBar(context: context, message: res.data, isError: true)
            .show();

        resposta.resultado = Resposta.ERROR;
        return resposta;
      } else {
        throw Exception(res.statusCode.toString() + ": Erro ao buscar turmas.");
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

  // entrar em uma turma
  Future<Resposta> entrarTurma(context, String codigo) async {
    Resposta resposta = Resposta();

    String data = codigo;

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.post("/entrarTurma", data: data);

      if (res.statusCode == 200) {
        CustomSnackBar(
                context: context,
                message: "Você foi adicionado a turma " + res.data['nome'],
                isError: false)
            .show();

        resposta.resultado = Resposta.SUCESS;
        resposta.object = Turma(id: res.data['id'], nome: res.data['nome']);
        return resposta;
      } else if (res.statusCode == 400 || res.statusCode == 404) {
        CustomSnackBar(context: context, message: res.data, isError: true)
            .show();

        resposta.resultado = Resposta.ERROR;
        return resposta;
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
      resposta.resultado = Resposta.FATAL_ERROR;
      return resposta;
    }
  }
}
