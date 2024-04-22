import 'package:flutter/material.dart';
import 'draw.dart'; // Importe a página draw.dart aqui

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Adicione ação para o menu de 3 barras
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('URL_DA_IMAGEM'),
              radius: 30,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _mostrarDialogoCriar(context);
              },
              child: Text('Criar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ação para o botão "Importar"
              },
              child: Text('Importar'),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoCriar(BuildContext context) {
    int altura = 0;
    int largura = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Criar Pixel Art'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  altura = int.tryParse(value) ?? 0;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Altura',
                ),
              ),
              TextField(
                onChanged: (value) {
                  largura = int.tryParse(value) ?? 0;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Largura',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Criar a pixel art com os valores de altura e largura
                // Navegar para a página draw.dart com os valores de altura e largura
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DrawPage(altura: altura, largura: largura),
                  ),
                );
              },
              child: Text('Criar'),
            ),
          ],
        );
      },
    );
  }
}
