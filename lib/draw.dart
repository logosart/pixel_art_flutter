import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DrawPage extends StatefulWidget {
  final int altura;
  final int largura;

  DrawPage({required this.altura, required this.largura});

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  List<List<Color>> pixels = [];
  Color _selectedColor = Colors.black;
  Color _originalColor = Colors.white;

  final GlobalKey _globalKey = GlobalKey(); // Adicionando GlobalKey

  @override
  void initState() {
    super.initState();
    _inicializarPixels();
  }

  void _inicializarPixels() {
    for (int i = 0; i < widget.altura; i++) {
      pixels.add(List<Color>.filled(widget.largura, Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoPixel = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Desenho'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Adicione ação para o menu de 3 barras
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildColorPalette(),
          _buildToolPalette(),
          Expanded(
            child: Center(
              child: RepaintBoundary( // Adicionando RepaintBoundary com GlobalKey
                key: _globalKey,
                child: SizedBox(
                  width: tamanhoPixel * widget.largura,
                  height: tamanhoPixel * widget.altura,
                  child: GridView.builder(
                    itemCount: widget.altura * widget.largura,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.largura,
                    ),
                    itemBuilder: (context, index) {
                      int linha = index ~/ widget.largura;
                      int coluna = index % widget.largura;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            pixels[linha][coluna] =
                                _selectedColor == _originalColor
                                    ? Colors.white
                                    : _selectedColor;
                          });
                        },
                        child: Container(
                          width: tamanhoPixel,
                          height: tamanhoPixel,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: pixels[linha][coluna],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton( // Adicionando FloatingActionButton para salvar
        onPressed: _captureImage,
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildColorPalette() {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 8),
          _buildColorButton(Colors.black),
          _buildColorButton(Colors.red),
          _buildColorButton(Colors.blue),
          _buildColorButton(Colors.green),
          _buildColorButton(Colors.yellow),
          _buildColorButton(Colors.orange),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: _selectedColor == color ? Colors.white : Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildToolPalette() {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 8),
          _buildToolButton('Borracha'),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildToolButton(String toolName) {
    return GestureDetector(
      onTap: () {
        // Adicione ação para a ferramenta selecionada
        if (toolName == 'Borracha') {
          setState(() {
            _selectedColor = _originalColor;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(9),
        ),
        child: toolName == 'Borracha' ? Image.asset('assets/borracha.png') : Text(toolName),
      ),
    );
  }

  void _captureImage() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(pngBytes); // Salva a imagem na galeria
      print(result);
    } catch (e) {
      print(e);
    }
  }
}
