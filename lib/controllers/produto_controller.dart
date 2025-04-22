import '../models/produto.dart';

class ProdutoController {
  static final List<Produto> _produtos = [];

  static Future<List<Produto>> listar() async {
    return _produtos;
  }

  static Future<void> salvar(Produto produto) async {
    if (produto.nome.isEmpty ||
        produto.unidade.isEmpty ||
        produto.qtdEstoque <= 0 ||
        produto.precoVenda <= 0) {
      throw Exception('Nome, Unidade, Estoque e Preço são obrigatórios');
    }

    final index = _produtos.indexWhere((p) => p.id == produto.id);

    if (index >= 0) {
      _produtos[index] = produto; // Atualiza
    } else {
      produto.id = DateTime.now().millisecondsSinceEpoch;
      _produtos.add(produto); // Adiciona
    }
  }

  static Future<void> excluir(int id) async {
    _produtos.removeWhere((p) => p.id == id);
  }
}
