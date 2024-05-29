class Usuario {
  final int idUsuario;
  final String nome;
  final String email;
  final String? senha;
  final bool? ativado;
  final String? token;

  Usuario(
      // Construtor
      {required this.idUsuario,
      required this.nome,
      required this.email,
      this.senha,
      this.ativado,
      this.token});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    // Conversão entre jason e usuario
    return Usuario(
        idUsuario: (json['idUsuario'] as int),
        nome: (json['nome'] as String),
        email: (json['email'] as String),
        senha: (json['senha'] as String?),
        ativado: (json['ativado'] as bool?),
        token: (json['token'] as String?));
  }
}
