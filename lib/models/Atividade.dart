import 'dart:core';

import 'package:tc_2024_fluencee_mobile/models/Turma.dart';

class Atividade {
  final int id;
  final Turma? turma;
  final String? nome;
  final String? enunciado;
  final int? tipoAtividade;
  final double? notaValor;
  final int? quantidadeAlunos;
  final int? status;
  // final List<Questoes> questoes;

  Atividade(
      {required this.id,
      this.turma,
      this.nome,
      this.enunciado,
      this.tipoAtividade,
      this.notaValor,
      this.quantidadeAlunos,
      this.status});

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
        id: (json['id'] as int),
        nome: (json['nome'] as String),
        turma: Turma.fromJson(json['turma']),
        enunciado: (json['enunciado'] as String),
        tipoAtividade: (json['tipoAtividade'] as int),
        notaValor: (json['notaValor'] as double),
        quantidadeAlunos: (json['quantidadeAlunos'] as int),
        status: (json['status'] as int));
  }

  static List<Atividade> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Atividade.fromJson(json)).toList();
  }
}
