import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/usuario.dart';

class UsuarioController {
  static const String _fileName = 'usuarios.json';

  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  static Future<List<Usuario>> listar() async {
    try {
      final file = await _getFile();
      if (!file.existsSync()) return [];
      final jsonString = await file.readAsString();
      final List jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => Usuario.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> salvar(Usuario usuario) async {
    final lista = await listar();
    lista.removeWhere((u) => u.id == usuario.id); // Evita duplicidade
    lista.add(usuario);
    final file = await _getFile();
    await file.writeAsString(jsonEncode(lista.map((u) => u.toMap()).toList()));
  }

  static Future<void> excluir(int id) async {
    final lista = await listar();
    lista.removeWhere((u) => u.id == id);
    final file = await _getFile();
    await file.writeAsString(jsonEncode(lista.map((u) => u.toMap()).toList()));
  }

  static Future<Usuario?> autenticar(String nome, String senha) async {
    final lista = await listar();
    return lista.firstWhere(
      (u) => u.nome == nome && u.senha == senha,
      orElse: () => Usuario(id: -1, nome: '', senha: ''),
    ).id != -1 ? lista.firstWhere((u) => u.nome == nome && u.senha == senha) : null;
  }

  static Future<bool> existeUsuarioCadastrado() async {
    final lista = await listar();
    return lista.isNotEmpty;
  }
}