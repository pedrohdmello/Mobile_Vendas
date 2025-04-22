import 'package:flutter/material.dart';
import '../controllers/usuario_controller.dart';
import 'cadastro_usuario.dart';
import 'menu.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _nomeController = TextEditingController();
  final _senhaController = TextEditingController();
  String _erro = '';

  void _login() async {
    final usuariosExistem = await UsuarioController.existeUsuarioCadastrado();

    final nome = _nomeController.text.trim();
    final senha = _senhaController.text.trim();

    if (!usuariosExistem && nome == 'admin' && senha == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Menu()),
      );
      return;
    }

    final usuario = await UsuarioController.autenticar(nome, senha);
    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Menu()),
      );
    } else {
      setState(() {
        _erro = 'Usuário ou senha inválidos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: const Text('Entrar')),
            if (_erro.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(_erro, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CadastroUsuario()),
                );
              },
              child: const Text('Ir para cadastro de usuário'),
            ),
          ],
        ),
      ),
    );
  }
}
