import 'package:flutter/material.dart';
import 'draw.dart'; // Importe a página draw.dart aqui

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 71, 71, 71), // Define a cor de fundo da appbar como cinza
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar( // Move o perfil para o canto superior esquerdo
            backgroundImage: NetworkImage('URL_DA_IMAGEM'),
            radius: 20,
          ),
        ),
        title: Center(child: Text('Home')), // Centraliza o texto 'Home' na appbar
        actions: [
          IconButton(
            icon: Icon(Icons.menu), // Adiciona o ícone do menu de 3 barras no lado superior direito
            onPressed: () {
              // Adicione ação para o menu de 3 barras
            },
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 92, 92, 92), // Altera a cor do corpo da tela para vermelho
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _mostrarDialogoCriar(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50), // Define o tamanho mínimo do botão "Criar"
                ),
                child: Text('Criar'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _importarPixelArt(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50), // Define o tamanho mínimo do botão "Importar"
                ),
                child: Text('Importar'),
              ),
            ],
          ),
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

  void _importarPixelArt(BuildContext context) {
    // Ação para o botão "Importar"
  }
}
