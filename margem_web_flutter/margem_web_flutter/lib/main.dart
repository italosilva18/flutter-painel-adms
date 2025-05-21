// main.dart
import 'package:flutter/material.dart';
import 'package:margem_web_flutter/screens/login_screen.dart'; // Importe a tela de login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MargemWeb Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Defina a tela de login como a tela inicial
    );
  }
}
