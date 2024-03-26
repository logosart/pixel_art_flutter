import 'package:flutter/material.dart';
import 'package:trabalho_semestre_flutter/components/pixel.dart';

class PixelArtPage extends StatefulWidget {
  final int rows;
  final int columns;

  const PixelArtPage({super.key, required this.rows, required this.columns});

  
  @override
  _PixelArtPageState createState() => _PixelArtPageState(rows: rows, columns: columns);
}

class _PixelArtPageState extends State<PixelArtPage> {
  final int rows;
  final int columns;
  late List<List<Color>> pixels;

  _PixelArtPageState({required this.rows, required this.columns});

  @override
  void initState() {
    super.initState();
    // Inicializa a grade de pixels com cores transparentes
    pixels = List.generate(rows, (r) => List.generate(columns, (c) => Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pixel Art'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
        ),
        itemCount: rows * columns,
        itemBuilder: (context, index) {
          int row = index ~/ columns;
          int column = index % columns;
          return Pixel(color: pixels[row][column]);
        },
      ),
    );
  }
}