import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/alertas/snackbar.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';
import 'package:tc_2024_fluencee_mobile/interceptor/dio-interceptor.dart';
import 'package:tc_2024_fluencee_mobile/models/Atividade.dart';
import 'package:tc_2024_fluencee_mobile/models/EstudanteGrupo.dart';
import 'package:tc_2024_fluencee_mobile/models/Questao.dart';
import 'package:tc_2024_fluencee_mobile/models/Respostabd.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';
import 'package:tc_2024_fluencee_mobile/utils/resposta.dart';

class RespostaService {
  late Dio dio;

  RespostaService() {
    dio = Dio(BaseOptions(
      baseUrl: '${ApiService.apiUrl}/resposta',
      validateStatus: (status) {
        return true;
      },
    ));
    dio.interceptors.add(DioInterceptor());
  }

  Future<Resposta> responder(context, Questao questao, Atividade atividade,
      RespostaBD respostaBD) async {
    Resposta resposta = Resposta();

    Map<String, dynamic> data = {
      'resposta': respostaBD.resposta,
    };

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio
          .post("/responder/${questao.id}/${atividade.id}", data: data);

      if (res.statusCode == 200) {
        CustomSnackBar(
                context: context, message: "Questao respondida", isError: false)
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

  Future<Resposta> listarRespostas(context, Atividade atividade) async {
    Resposta resposta = Resposta();

    dio.options.contentType = 'application/json';

    try {
      final Response res = await dio.get("/listarRespostas${atividade.id}");

      if (res.statusCode == 200) {
        print(res.data);

        List<dynamic> dataList = res.data;
        List<EstudanteGrupo> estudanteGrupos =
            EstudanteGrupo.fromJsonList(dataList);
        resposta.object = estudanteGrupos;
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
}
