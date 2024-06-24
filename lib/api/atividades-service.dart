import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/alertas/snackbar.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/components/atividades/criar-editar-atividade.dart';
import 'package:tc_2024_fluencee_mobile/interceptor/dio-interceptor.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/Questao.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';
import 'package:tc_2024_fluencee_mobile/utils/resposta.dart';

class AtividadeService {
  late Dio dio;

  AtividadeService() {
    dio = Dio(BaseOptions(
      baseUrl: '${ApiService.apiUrl}/atividade',
      validateStatus: (status) {
        return true;
      },
    ));
    dio.interceptors.add(DioInterceptor());
  }

  Future<Resposta> cadastrar(context, Atividade atividade, Turma turma) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'nome': atividade.nome,
      'enunciado': atividade.enunciado,
      'tipoAtividade': atividade.tipoAtividade,
      'notaValor': atividade.notaValor
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res =
          await dio.post("/criarAtividade/${turma.id}", data: data);

      if (res.statusCode == 200) {
        CustomSnackBar(
                context: context,
                message: "Atividade criada com sucesso",
                isError: false)
            .show();

        resposta.resultado = Resposta.SUCESS;
        resposta.object = Atividade(id: res.data['id']);
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

  Future<Resposta> listarAtividades(context, Turma turma) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'id': turma.id,
      'nome': turma.nome,
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.post("/listarAtividades", data: data);

      if (res.statusCode == 200) {
        print(res.data);

        List<dynamic> dataList = res.data;
        List<Atividade> atividadesTurma = Atividade.fromJsonList(dataList);
        resposta.object = atividadesTurma;
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

  Future<Resposta> editarAtividade(context, Atividade atividade) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'id': atividade.id,
      'nome': atividade.nome,
      'enunciado': atividade.enunciado,
      'notaValor': atividade.notaValor
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.put("/editarAtividade", data: data);

      print(res.statusCode);

      if (res.statusCode == 200) {
        CustomSnackBar(
                context: context,
                message: "Atividade alterada com sucesso",
                isError: false)
            .show();

        resposta.resultado = Resposta.SUCESS;
        return resposta;
      } else if (res.statusCode == 400 ||
          res.statusCode == 404 ||
          res.statusCode == 403) {
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

  Future<Resposta> excluirAtividade(context, Atividade atividade) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'id': atividade.id,
      'nome': atividade.nome,
      'enunciado': atividade.enunciado,
      'notaValor': atividade.notaValor
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.put("/excluirAtividade", data: data);

      print(res.statusCode);

      if (res.statusCode == 200) {
        CustomSnackBar(
                context: context,
                message: "Atividade excluída com sucesso",
                isError: false)
            .show();

        resposta.resultado = Resposta.SUCESS;
        return resposta;
      } else if (res.statusCode == 400 ||
          res.statusCode == 404 ||
          res.statusCode == 403) {
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

  Future<Resposta> listarQuestoes(context, Atividade atividade) async {
    Resposta resposta = Resposta();

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.get("/listarQuestoes/${atividade.id}");

      if (res.statusCode == 200) {
        print(res.data);

        List<dynamic> dataList = res.data;
        List<Questao> questoes = Questao.fromJsonList(dataList);
        resposta.object = questoes;
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

  Future<Resposta> removerQuestoes(
      context, int idQuestao, int idAtividade) async {
    Resposta resposta = Resposta();

    dio.options.contentType = 'application/json';

    try {
      final Response res =
          await dio.delete("/removerQuestao/${idAtividade}/$idQuestao");

      if (res.statusCode == 200) {
        print(res.data);

        CustomSnackBar(
                context: context,
                message:
                    'Questão removida da atividade, mas permanece no banco de questões.',
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

  Future<Resposta> iniciarAtividade(context, Atividade atividade) async {
    Resposta resposta = Resposta();

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.put("/iniciarAtividade/${atividade.id}");

      print(res.statusCode);

      if (res.statusCode == 200) {
        CustomSnackBar(
                context: context,
                message: "Atividade iniciada com sucesso",
                isError: false)
            .show();

        resposta.resultado = Resposta.SUCESS;
        return resposta;
      } else if (res.statusCode == 400 ||
          res.statusCode == 404 ||
          res.statusCode == 403) {
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
