class RespostaBD {
  final int id;
  final String resposta;
  final String? comentario;
  final double? nota;
  final String? nomeQuestao;
  final String? enunciadoQuestao;

  RespostaBD(
      {required this.id,
      required this.resposta,
      this.comentario,
      this.nota,
      this.nomeQuestao,
      this.enunciadoQuestao});

  factory RespostaBD.fromJson(Map<String, dynamic> json) {
    return RespostaBD(
        id: (json['id'] as int),
        resposta: (json['resposta'] as String),
        comentario: (json['comentario'] as String?),
        nota: (json['nota'] as double?),
        nomeQuestao: (json['nomeQuestao'] as String?),
        enunciadoQuestao: (json['enunciadoQuestao'] as String?));
  }

  static List<RespostaBD> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RespostaBD.fromJson(json)).toList();
  }
}
