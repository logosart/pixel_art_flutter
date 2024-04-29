import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
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
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                  int coluna = (localPosition.dx / tamanhoPixel).floor();
                  int linha = (localPosition.dy / tamanhoPixel).floor();
                  if (linha >= 0 &&
                      linha < widget.altura &&
                      coluna >= 0 &&
                      coluna < widget.largura) {
                    pixels[linha][coluna] = _selectedColor == _originalColor ? Colors.white : _selectedColor;
                  }
                });
              },
              child: CustomPaint(
                size: Size(tamanhoPixel * widget.largura, tamanhoPixel * widget.altura),
                painter: DrawingPainter(pixels: pixels, tamanhoPixel: tamanhoPixel),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(widget.largura.toDouble(), widget.altura.toDouble())));
      DrawingPainter(pixels: pixels, tamanhoPixel: 20.0).paint(canvas, Size(widget.largura.toDouble() * 20.0, widget.altura.toDouble() * 20.0));
      final picture = recorder.endRecording();
      final img = await picture.toImage(widget.largura * 20, widget.altura * 20);
      final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
      final result = await ImageGallerySaver.saveImage(Uint8List.view(pngBytes!.buffer)); // Save image to gallery
      print(result);
    } catch (e) {
      print(e);
    }
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<Color>> pixels;
  final double tamanhoPixel;

  DrawingPainter({required this.pixels, required this.tamanhoPixel});

  @override
  void paint(Canvas canvas, Size size) {
    for (int linha = 0; linha < pixels.length; linha++) {
      for (int coluna = 0; coluna < pixels[linha].length; coluna++) {
        Paint paint = Paint()..color = pixels[linha][coluna];
        canvas.drawRect(Rect.fromLTWH(coluna * tamanhoPixel, linha * tamanhoPixel, tamanhoPixel, tamanhoPixel), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
