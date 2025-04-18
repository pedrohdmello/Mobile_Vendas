import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../controllers/usuario_controller.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  final _nomeController = TextEditingController();
  final _senhaController = TextEditingController();
  List<Usuario> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  void _carregarUsuarios() async {
    final lista = await UsuarioController.listar();
    setState(() {
      _usuarios = lista;
    });
  }

  void _salvarUsuario() async {
    if (_nomeController.text.isEmpty || _senhaController.text.isEmpty) {
      _mostrarErro('Preencha todos os campos obrigatórios.');
      return;
    }

    final novoUsuario = Usuario(
      id: _usuarioEditando?.id ?? DateTime.now().millisecondsSinceEpoch,
      nome: _nomeController.text,
      senha: _senhaController.text,
    );

    await UsuarioController.salvar(novoUsuario);
    _nomeController.clear();
    _senhaController.clear();
    _carregarUsuarios();
  }

  void _removerUsuario(int id) async {
    await UsuarioController.excluir(id);
    _carregarUsuarios();
  }
  Usuario? _usuarioEditando;
  void _editarUsuario(Usuario usuario) {
  setState(() {
    _usuarioEditando = usuario;
    _nomeController.text = usuario.nome;
    _senhaController.text = usuario.senha;
  });
}

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensagem),
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
      appBar: AppBar(title: const Text('Cadastro de Usuários')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomeController,
              decoration: _inputStyle('Nome *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _senhaController,
              decoration: _inputStyle('Senha *'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _salvarUsuario,
              icon: const Icon(Icons.save),
              label: const Text('Salvar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Usuários cadastrados:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _usuarios.isEmpty
                  ? const Center(child: Text('Nenhum usuário cadastrado.'))
                  : ListView.builder(
                      itemCount: _usuarios.length,
                      itemBuilder: (_, index) {
                        final u = _usuarios[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(u.nome),
                            trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editarUsuario(u),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removerUsuario(u.id),
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
