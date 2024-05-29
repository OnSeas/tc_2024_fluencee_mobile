class TrocarSenha {
  final String senhaAntiga;
  final String senhaNova;

  TrocarSenha( // Construtor
      {
    required this.senhaAntiga,
    required this.senhaNova,
  });

  factory TrocarSenha.fromJson(Map<String, dynamic> json) {
    // Conversão entre jason e model
    return TrocarSenha(
      senhaAntiga: (json['senhaAntiga'] as String),
      senhaNova: (json['senhaNova'] as String),
    );
  }
}
