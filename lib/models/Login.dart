class Login {
  final String login;
  final String senha;

  Login( // Construtor
      {
    required this.login,
    required this.senha,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    // Conversão entre jason e model
    return Login(
      login: (json['login'] as String),
      senha: (json['senha'] as String),
    );
  }
}
