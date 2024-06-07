class Turma {
  final int id;
  final String? nome;
  final String? ano;
  final String? sala;
  final String? codigo;
  final bool? ativado;
  final bool? eProfessor;

  Turma({
    required this.id,
    this.nome,
    this.ano,
    this.sala,
    this.codigo,
    this.ativado,
    this.eProfessor,
  });

  factory Turma.fromJson(Map<String, dynamic> json) {
    // Conversão entre jason e usuario
    return Turma(
      id: (json['id'] as int),
      nome: (json['nome'] as String),
      sala: (json['sala'] as String?),
      ano: (json['ano'] as String?),
      ativado: (json['ativado'] as bool?),
      codigo: (json['codigo'] as String?),
      eProfessor: (json['eProfessor'] as bool?),
    );
  }

  static List<Turma> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Turma.fromJson(json)).toList();
  }
}
