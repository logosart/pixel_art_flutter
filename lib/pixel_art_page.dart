import 'package:flutter/material.dart';

class PixelArtPage extends StatefulWidget {
  final int rows;
  final int columns;

  PixelArtPage({required this.rows, required this.columns});

  @override
  _PixelArtPageState createState() => _PixelArtPageState();
}

class _PixelArtPageState extends State<PixelArtPage> {
  late List<List<Color>> pixels;
  bool eraserMode = false; // Adiciona um estado para o modo borracha
  Color currentColor = Colors.black; // Adiciona um estado para a cor atual

  @override
  void initState() {
    super.initState();
    // Inicializa a grade de pixels com cores transparentes
    pixels = List.generate(widget.rows, (r) => List.generate(widget.columns, (c) => Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pixel Art'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0), // Adiciona um padding ao redor da grade
        child: Center( // Centraliza a grade na tela
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: Colors.primaries.map((color) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color, // Define a cor do botão
                  ),
                  onPressed: () => setState(() {
                    currentColor = color;
                    eraserMode = false;
                  }),
                  child: SizedBox(width: 20, height: 20), // Define o tamanho do botão
                )).toList(),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.columns,
                  ),
                  itemCount: widget.rows * widget.columns,
                  itemBuilder: (context, index) {
                    int row = index ~/ widget.columns;
                    int column = index % widget.columns;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          pixels[row][column] = eraserMode ? Colors.transparent : currentColor; // Altera a cor do pixel para a cor atual ou transparente dependendo do modo
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromARGB(255, 87, 87, 87)),
                          color: pixels[row][column],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
