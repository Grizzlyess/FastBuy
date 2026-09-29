class Produto {
  final int? id;
  final String nome;
  final int quantidade;
  final double valor;
  final String? imagemPath; 

  Produto({
    this.id,
    required this.nome,
    required this.quantidade,
    required this.valor,
    this.imagemPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'quantidade': quantidade,
      'valor': valor,
      'imagemPath': imagemPath,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      quantidade: map['quantidade'],
      valor: map['valor'],
      imagemPath: map['imagemPath'],
    );
  }
}