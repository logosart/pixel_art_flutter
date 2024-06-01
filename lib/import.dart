// import.dart

import 'package:flutter/material.dart';

class ImportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Importar Imagem'),
      ),
      body: Container(
        color: Color.fromARGB(255, 83, 83, 83), // Defina a cor de fundo aqui
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              // Implemente a funcionalidade para selecionar uma imagem da galeria
              // e passar para a página de desenho.
            },
            child: Text('Selecionar Imagem'),
          ),
        ),
      ),
    );
  }
}
