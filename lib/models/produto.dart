class Produto {
  int id;
  String nome;
  String unidade;
  int qtdEstoque;
  double precoVenda;
  int status; //(0 - Ativo\ 1 - Inativo)
  double? custo;
  String? codigoBarra;

  Produto({
    required this.id,
    required this.nome,
    required this.unidade,
    required this.qtdEstoque,
    required this.precoVenda,
    required this.status,
    this.custo,
    this.codigoBarra,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      unidade: json['unidade'],
      qtdEstoque: json['qtdEstoque'],
      precoVenda: (json['precoVenda'] as num).toDouble(),
      status: json['status'],
      custo: json['custo'] != null ? (json['custo'] as num).toDouble() : null,
      codigoBarra: json['codigoBarra'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'unidade': unidade,
      'qtdEstoque': qtdEstoque,
      'precoVenda': precoVenda,
      'status': status,
      'custo': custo,
      'codigoBarra': codigoBarra,
    };
  }
}
