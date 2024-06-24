import 'package:tc_2024_fluencee_mobile/models/Opcao.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';

class Questao {
  final int id;
  final String? nome;
  final String? enunciado;
  final String? gabarito;
  final int? tipo;
  final Usuario? usuarioCriador;
  final double? nota;
  final List<Opcao>? opcoes;
  final bool? respondida;

  Questao(
      {required this.id,
      this.nome,
      this.enunciado,
      this.gabarito,
      this.tipo,
      this.usuarioCriador,
      this.nota,
      this.opcoes,
      this.respondida});

  factory Questao.fromJson(Map<String, dynamic> json) {
    return Questao(
        id: (json['id'] as int),
        nome: (json['nome'] as String),
        enunciado: (json['enunciado'] as String),
        gabarito: (json['gabarito'] as String?),
        tipo: (json['tipo'] as int),
        usuarioCriador: Usuario.fromJson(json['usuarioCriador']),
        nota: (json['nota'] as double?),
        opcoes:
            json['opcoes'] != null ? Opcao.fromJsonList(json['opcoes']) : null,
        respondida: json['respondida'] as bool?);
  }

  static List<Questao> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Questao.fromJson(json)).toList();
  }
}
