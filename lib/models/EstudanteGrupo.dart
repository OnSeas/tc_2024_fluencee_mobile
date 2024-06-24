import 'package:tc_2024_fluencee_mobile/models/RespostaBD.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';

class EstudanteGrupo {
  final Usuario estudante;
  final List<RespostaBD> respostas;

  EstudanteGrupo({required this.estudante, required this.respostas});

  factory EstudanteGrupo.fromJson(Map<String, dynamic> json) {
    return EstudanteGrupo(
      estudante: Usuario.fromJson(json['estudante']),
      respostas: (json['respostas'] as List)
          .map((respostaJson) => RespostaBD.fromJson(respostaJson))
          .toList(),
    );
  }

  static List<EstudanteGrupo> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EstudanteGrupo.fromJson(json)).toList();
  }
}
