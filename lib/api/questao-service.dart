import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/alertas/snackbar.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/interceptor/dio-interceptor.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/Questao.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';
import 'package:tc_2024_fluencee_mobile/utils/resposta.dart';

class QuestaoService {
  late Dio dio;

  QuestaoService() {
    dio = Dio(BaseOptions(
      baseUrl: '${ApiService.apiUrl}/questao',
      validateStatus: (status) {
        return true;
      },
    ));
    dio.interceptors.add(DioInterceptor());
  }

  Future<Resposta> criarQuestao(
      context, Questao questao, Atividade atividade) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'tipo': questao.tipo,
      'nome': questao.nome,
      'enunciado': questao.enunciado,
      'nota': questao.nota,
      if (questao.tipo == 2)
        'opcoes': questao.opcoes!.map((opcao) => opcao.toJson()).toList()
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res =
          await dio.post("/criarQuestao/${atividade.id}", data: data);

      if (res.statusCode == 200) {
        CustomSnackBar(
                context: context,
                message: "Questão criada com sucesso",
                isError: false)
            .show();

        resposta.resultado = Resposta.SUCESS;
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
      Navigator.popAndPushNamed(context, AppRoutes.TELA_LOGIN);
      resposta.resultado = Resposta.FATAL_ERROR;
      return resposta;
    }
  }

  Future<Resposta> editarQuestao(
      context, Questao questao, int idAtividade) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'id': questao.id,
      'tipo': questao.tipo,
      'nome': questao.nome,
      'enunciado': questao.enunciado,
      'nota': questao.nota
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res =
          await dio.put("/editarQuestao/${idAtividade}", data: data);

      print(res.statusCode);

      if (res.statusCode == 200) {
        CustomSnackBar(
                context: context,
                message: "Questão alterada com sucesso",
                isError: false)
            .show();

        resposta.resultado = Resposta.SUCESS;
        return resposta;
      } else if (res.statusCode == 400 || res.statusCode == 404) {
        CustomSnackBar(context: context, message: res.data, isError: true)
            .show();

        resposta.resultado = Resposta.ERROR;
        return resposta;
      } else {
        throw Exception("Status code: " + res.statusCode.toString() + res.data);
      }
    } catch (e) {
      print('Erro na solicitação: $e');
      CustomSnackBar(
              context: context,
              message:
                  'Não foi possível se conectar com a aplicação, por favor tente novamente mais tarde!',
              isError: true)
          .show();
      Navigator.popAndPushNamed(context, AppRoutes.TELA_LOGIN);
      resposta.resultado = Resposta.FATAL_ERROR;
      return resposta;
    }
  }
}
