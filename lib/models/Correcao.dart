class Correcao {
  final int id;
  final String resposta;
  final String? comentario;
  final double? nota;
  final String? nomeQuestao;
  final String? enunciadoQuestao;

  Correcao(
      {required this.id,
      required this.resposta,
      this.comentario,
      this.nota,
      this.nomeQuestao,
      this.enunciadoQuestao});
}
