import 'package:flutter/material.dart';
import 'package:flutter_pixel/home.dart';
import 'cadastro.dart'; // Importe sua página de cadastro aqui

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu Aplicativo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Defina a página de cadastro como a página inicial
    );
  }
}
