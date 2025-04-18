import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../controllers/produto_controller.dart';

class CadastroProduto extends StatefulWidget {
  const CadastroProduto({super.key});

  @override
  State<CadastroProduto> createState() => _CadastroProdutoState();
}

class _CadastroProdutoState extends State<CadastroProduto> {
  final _nomeController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _estoqueController = TextEditingController();
  final _precoController = TextEditingController();
  final _statusController = TextEditingController();
  final _custoController = TextEditingController();
  final _codigoBarrasController = TextEditingController();
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }
  
  Produto? _produtoEditando;

  void _carregarProdutos() async {
    final lista = await ProdutoController.listar();
    setState(() {
      _produtos = lista;
    });
  }
  
  

  void _salvarProduto() async {
    if (_nomeController.text.isEmpty ||
        _unidadeController.text.isEmpty ||
        _estoqueController.text.isEmpty ||
        _precoController.text.isEmpty ||
        _statusController.text.isEmpty) {
      _mostrarErro('Preencha todos os campos obrigatórios.');
      return;
    }

    final novoProduto = Produto(
      id: _produtoEditando?.id ?? DateTime.now().millisecondsSinceEpoch,
      nome: _nomeController.text,
      unidade: _unidadeController.text,
      qtdEstoque: int.tryParse(_estoqueController.text) ?? 0,
      precoVenda: double.tryParse(_precoController.text) ?? 0,
      status: 0,
      custo: double.tryParse(_custoController.text) ?? 0,
      codigoBarra: _codigoBarrasController.text,

    );

    await ProdutoController.salvar(novoProduto);
    _limparCampos();
    _carregarProdutos();
  }

  void _limparCampos() {
    _produtoEditando = null;
    _nomeController.clear();
    _unidadeController.clear();
    _estoqueController.clear();
    _precoController.clear();
    _statusController.clear();
    _custoController.clear();
    _codigoBarrasController.clear();
  }

  void _removerProduto(int id) async {
    await ProdutoController.excluir(id);
    _carregarProdutos();
  }

  void _editarProduto(Produto produto) {
  setState(() {
    _produtoEditando = produto;
    _nomeController.text = produto.nome;
    _unidadeController.text = produto.unidade;
    _estoqueController.text = produto.qtdEstoque.toString();
    _precoController.text = produto.precoVenda.toString();
    _statusController.text = produto.status.toString();
    _custoController.text = (produto.custo ?? 0).toString();
    _codigoBarrasController.text = produto.codigoBarra ?? '';
  });
}

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    ));
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Produtos')),
      body: Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              TextField(controller: _nomeController, decoration: _inputStyle('Nome *')),
              const SizedBox(height: 12),
              TextField(controller: _unidadeController, decoration: _inputStyle('Unidade *')),
              const SizedBox(height: 12),
              TextField(
                controller: _estoqueController,
                decoration: _inputStyle('Qtd. Estoque *'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _precoController,
                decoration: _inputStyle('Preço de Venda *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _statusController,
                decoration: _inputStyle('Status - 0 ou 1 *'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _custoController,
                decoration: _inputStyle('Custo do Produto'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _codigoBarrasController,
                decoration: _inputStyle('Código de Barras'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvarProduto,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Produtos cadastrados:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 250,
        child: _produtos.isEmpty
            ? const Center(child: Text('Nenhum produto cadastrado.'))
            : ListView.builder(
                itemCount: _produtos.length,
                itemBuilder: (_, index) {
                  final p = _produtos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(p.nome),
                      subtitle: Text(
                        'Unidade: ${p.unidade} | Estoque: ${p.qtdEstoque} | Preço: R\$ ${p.precoVenda.toStringAsFixed(2)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editarProduto(p),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerProduto(p.id),
                          ),
                        ],
                      ),

                    ),
                  );
                },
              ),
      ),
    ],
  ),
),
    );
  }
}
