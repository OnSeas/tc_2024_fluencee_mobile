class Opcao {
  final int id;
  final String? textoOpcao;
  final bool? opcaoCorreta;

  Opcao({required this.id, this.textoOpcao, this.opcaoCorreta});

  factory Opcao.fromJson(Map<String, dynamic> json) {
    return Opcao(
        id: (json['id'] as int),
        textoOpcao: (json['textoOpcao'] as String),
        opcaoCorreta: (json['opcaoCorreta'] as bool));
  }

  static List<Opcao> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Opcao.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'textoOpcao': textoOpcao, 'opcaoCorreta': opcaoCorreta};
  }
}
