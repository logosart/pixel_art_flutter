import 'package:flutter/material.dart';
import 'package:trabalho_semestre_flutter/setup_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Art App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SetupPage(),
    );
  }
}
