import '../models/cliente.dart';

class ClienteController {
  static final List<Cliente> _clientes = [];

  static Future<List<Cliente>> listar() async {
    return _clientes;
  }

  static Future<void> salvar(Cliente cliente) async {
    if (cliente.nome.isEmpty || cliente.tipo.isEmpty || cliente.cpfCnpj.isEmpty) {
      throw Exception('Nome, Tipo e CPF/CNPJ são obrigatórios');
    }

    final index = _clientes.indexWhere((c) => c.id == cliente.id);

    if (index >= 0) {
      _clientes[index] = cliente; // Atualiza
    } else {
      cliente.id = DateTime.now().millisecondsSinceEpoch;
      _clientes.add(cliente); // Adiciona novo
    }
  }

  static Future<void> excluir(int id) async {
    _clientes.removeWhere((c) => c.id == id);
  }
}
