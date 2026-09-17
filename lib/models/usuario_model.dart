class Usuario {
  final int? id;
  final String nome;
  final String estabelecimento;
  final String email;
  final String senha;

  Usuario({
    this.id,
    required this.nome,
    required this.estabelecimento,
    required this.email,
    required this.senha,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'estabelecimento': estabelecimento,
      'email': email,
      'senha': senha,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      estabelecimento: map['estabelecimento'],
      email: map['email'],
      senha: map['senha'],
    );
  }
}