
class Produto {
  final int? id;
  final String nome;
  final int quantidade;

  Produto({
    this.id,
    required this.nome,
    required this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'quantidade': quantidade,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'] as int,
      nome: map['nome'] as String,
      quantidade: map['quantidade'] as int,
    );
  }
}
