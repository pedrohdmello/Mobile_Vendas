import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/cliente.dart';

class ClienteController {
  static Future<String> _getFilePath() async { //Caminho do Arquivo
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/clientes.json';
  }

  static Future<List<Cliente>> listar() async { //Listar Clientes
    final filePath = await _getFilePath();
    final file = File(filePath);
    if (!(await file.exists())) return [];

    final jsonString = await file.readAsString();
    final jsonData = jsonDecode(jsonString) as List;
    return jsonData.map((e) => Cliente.fromJson(e)).toList();
  }

  static Future<void> salvar(Cliente cliente) async { //Salvar ou Atualizar Clientes
    if (cliente.nome.isEmpty || cliente.tipo.isEmpty || cliente.cpfCnpj.isEmpty) {
      throw Exception('Nome, Tipo e CPF/CNPJ são obrigatórios');
    }

    final lista = await listar();

    final existe = lista.indexWhere((c) => c.id == cliente.id);
    if (existe >= 0) {
      lista[existe] = cliente;
    } else {
      cliente.id = DateTime.now().millisecondsSinceEpoch;
      lista.add(cliente);
    }

    final filePath = await _getFilePath();
    final file = File(filePath);
    await file.writeAsString(jsonEncode(lista.map((c) => c.toJson()).toList()));
  }

  static Future<void> excluir(int id) async { //Excluir Cliente
    final lista = await listar();
    lista.removeWhere((c) => c.id == id);

    final filePath = await _getFilePath();
    final file = File(filePath);
    await file.writeAsString(jsonEncode(lista.map((c) => c.toJson()).toList()));
  }
}
