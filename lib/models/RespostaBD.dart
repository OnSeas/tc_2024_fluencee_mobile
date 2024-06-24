class RespostaBD {
  final int id;
  final String resposta;
  final String? comentario;
  final double? nota;

  RespostaBD(
      {required this.id, required this.resposta, this.comentario, this.nota});

  factory RespostaBD.fromJson(Map<String, dynamic> json) {
    return RespostaBD(
      id: (json['id'] as int),
      resposta: (json['resposta'] as String),
      comentario: (json['comentario'] as String?),
      nota: (json['nota'] as double?),
    );
  }

  static List<RespostaBD> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RespostaBD.fromJson(json)).toList();
  }
}
