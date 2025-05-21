// login_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MargemWeb Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo ou Imagem (se houver)
              //...

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Processar login
                    _login();
                  }
                },
                child: Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para realizar o login
  Future<void> _login() async {
    final url = 'https://api.painelmargem.com.br/mobile/login';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        // Login bem-sucedido
        // Navegar para a próxima tela ou realizar outras ações
        //...
        print('Login realizado com sucesso!');
      } else {
        // Login falhou
        // Exibir mensagem de erro para o usuário
        //...
        print(
            'Falha ao realizar o login. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      // Erro na requisição
      // Exibir mensagem de erro para o usuário
      //...
      print('Erro na requisição: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
