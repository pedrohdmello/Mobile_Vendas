import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../controllers/cliente_controller.dart';

class CadastroCliente extends StatefulWidget {
  const CadastroCliente({super.key});

  @override
  State<CadastroCliente> createState() => _CadastroClienteState();
}

class _CadastroClienteState extends State<CadastroCliente> {
  final _nomeController = TextEditingController();
  final _tipoController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();
  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  void _carregarClientes() async {
    final lista = await ClienteController.listar();
    setState(() {
      _clientes = lista;
    });
  }

  void _salvarCliente() async {
    if (_nomeController.text.isEmpty ||
        _tipoController.text.isEmpty ||
        _cpfCnpjController.text.isEmpty) {
      _mostrarErro('Todos os campos são obrigatórios.');
      return;
    }

    final novoCliente = Cliente(
      id: _clienteEditando?.id ?? DateTime.now().millisecondsSinceEpoch,
      nome: _nomeController.text,
      tipo: _tipoController.text,
      cpfCnpj: _cpfCnpjController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      cep: _cepController.text,
      endereco: _enderecoController.text,
      bairro: _bairroController.text,
      cidade: _cidadeController.text,
      uf: _ufController.text

    );

    await ClienteController.salvar(novoCliente);
    _limparCampos();
    _carregarClientes();
  }

  void _limparCampos() {
    _nomeController.clear();
    _tipoController.clear();
    _cpfCnpjController.clear();
    _bairroController.clear();
    _cidadeController.clear();
    _emailController.clear();
    _telefoneController.clear();
    _cepController.clear();
    _enderecoController.clear();
    _ufController.clear();
  }

  void _removerCliente(int id) async {
    await ClienteController.excluir(id);
    _carregarClientes();
  }
  Cliente? _clienteEditando;
  void _editarCliente(Cliente cliente) {
  setState(() {
    _clienteEditando = cliente;
    _nomeController.text = cliente.nome;
    _tipoController.text = cliente.tipo;
    _cpfCnpjController.text = cliente.cpfCnpj;
    _emailController.text = cliente.email ?? '';
    _telefoneController.text = cliente.telefone ?? '';
    _cepController.text = cliente.cep ?? '';
    _enderecoController.text = cliente.endereco ?? '';
    _bairroController.text = cliente.bairro ?? '';
    _cidadeController.text = cliente.cidade ?? '';
    _ufController.text = cliente.uf ?? '';
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
      appBar: AppBar(title: const Text('Cadastro de Clientes')),
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
              TextField(controller: _tipoController, decoration: _inputStyle('Tipo (F ou J) *')),
              const SizedBox(height: 12),
              TextField(controller: _cpfCnpjController, decoration: _inputStyle('CPF ou CNPJ *')),
              const SizedBox(height: 12),
              TextField(controller: _emailController, decoration: _inputStyle('E-mail')),
              const SizedBox(height: 12),
              TextField(controller: _telefoneController, decoration: _inputStyle('Telefone')),
              const SizedBox(height: 12),
              TextField(controller: _cepController, decoration: _inputStyle('CEP')),
              const SizedBox(height: 12),
              TextField(controller: _enderecoController, decoration: _inputStyle('Endereço')),
              const SizedBox(height: 12),
              TextField(controller: _bairroController, decoration: _inputStyle('Bairro')),
              const SizedBox(height: 12),
              TextField(controller: _cidadeController, decoration: _inputStyle('Cidade')),
              const SizedBox(height: 12),
              TextField(controller: _ufController, decoration: _inputStyle('UF')),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvarCliente,
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
                'Clientes cadastrados:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 100, // altura visível da lista
        child: _clientes.isEmpty
            ? const Center(child: Text('Nenhum cliente cadastrado.'))
            : ListView.builder(
                itemCount: _clientes.length,
                itemBuilder: (_, index) {
                  final c = _clientes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(c.nome),
                      subtitle: Text('${c.tipo} - ${c.cpfCnpj}'),
                      trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarCliente(c),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerCliente(c.id),
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
