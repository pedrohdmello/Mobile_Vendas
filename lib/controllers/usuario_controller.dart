import '../models/usuario.dart';

class UsuarioController {
  static final List<Usuario> _usuarios = [];

  static Future<List<Usuario>> listar() async {
    return _usuarios;
  }

  static Future<void> salvar(Usuario usuario) async {
    final index = _usuarios.indexWhere((u) => u.id == usuario.id);

    if (index >= 0) {
      _usuarios[index] = usuario;
    } else {
      usuario.id = DateTime.now().millisecondsSinceEpoch;
      _usuarios.add(usuario);
    }
  }

  static Future<void> excluir(int id) async {
    _usuarios.removeWhere((u) => u.id == id);
  }

  static Future<Usuario?> autenticar(String nome, String senha) async {
    try {
      return _usuarios.firstWhere((u) => u.nome == nome && u.senha == senha);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> existeUsuarioCadastrado() async {
    return _usuarios.isNotEmpty;
  }
}
