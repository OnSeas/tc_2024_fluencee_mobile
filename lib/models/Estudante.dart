import 'dart:ffi';

import 'package:tc_2024_fluencee_mobile/models/Turma.dart';
import 'package:tc_2024_fluencee_mobile/models/Usuario.dart';

class Estudante {
  final int id;
  final String? nome;
  final Turma turma;
  final Usuario estudante;
  final double? nota;
  late bool? bloqueado;

  Estudante({
    required this.id,
    this.nome,
    required this.turma,
    required this.estudante,
    this.nota,
    this.bloqueado,
  });

  factory Estudante.fromJson(Map<String, dynamic> json) {
    return Estudante(
        id: (json['id'] as int),
        nome: (json['nome'] as String),
        turma: Turma.fromJson(json['turma']),
        estudante: Usuario.fromJson(json['estudante']),
        nota: (json['nota'] as double?));
  }

  static List<Estudante> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Estudante.fromJson(json)).toList();
  }
}
