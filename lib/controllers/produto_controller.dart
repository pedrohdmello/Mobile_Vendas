import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/produto.dart';

class ProdutoController {
  static Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/produtos.json';
  }

  static Future<List<Produto>> listar() async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    if (!(await file.exists())) return [];

    final jsonString = await file.readAsString();
    final jsonData = jsonDecode(jsonString) as List;
    return jsonData.map((e) => Produto.fromJson(e)).toList();
  }

  static Future<void> salvar(Produto produto) async {
    if (produto.nome.isEmpty || produto.unidade.isEmpty || produto.qtdEstoque <=0 || produto.precoVenda <=0) {
      throw Exception('Nome, Unidade, Estoque e Preço são obrigatórios');
    }

    final lista = await listar();

    final existe = lista.indexWhere((p) => p.id == produto.id);
    if (existe >= 0) {
      lista[existe] = produto;
    } else {
      produto.id = DateTime.now().millisecondsSinceEpoch;
      lista.add(produto);
    }

    final filePath = await _getFilePath();
    final file = File(filePath);
    await file.writeAsString(jsonEncode(lista.map((p) => p.toJson()).toList()));
  }

  static Future<void> excluir(int id) async {
    final lista = await listar();
    lista.removeWhere((p) => p.id == id);

    final filePath = await _getFilePath();
    final file = File(filePath);
    await file.writeAsString(jsonEncode(lista.map((p) => p.toJson()).toList()));
  }
}
