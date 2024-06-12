import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImportDrawPage extends StatefulWidget {
  final Uint8List imageData;

  ImportDrawPage({required this.imageData});

  @override
  _ImportDrawPageState createState() => _ImportDrawPageState();
}

class _ImportDrawPageState extends State<ImportDrawPage> {
  List<PointData> points = [];
  Color _selectedColor = Colors.black;
  List<Color> colorList = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  ui.Image? _image;
  double pixelSize = 20.0; // Tamanho do pixel

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final codec = await ui.instantiateImageCodec(widget.imageData);
    final frame = await codec.getNextFrame();
    setState(() {
      _image = frame.image;
    });
  }

  void _drawPoint(Offset position) {
    setState(() {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      Offset localPosition = renderBox.globalToLocal(position);
      double x = localPosition.dx;
      double y = localPosition.dy;

      // Ajuste para a escala de pixels
      double adjustedX = x / MediaQuery.of(context).devicePixelRatio;
      double adjustedY = y / MediaQuery.of(context).devicePixelRatio;

      int col = (adjustedX / pixelSize).floor();
      int row = (adjustedY / pixelSize).floor();

      points.add(PointData(Offset(col * pixelSize, row * pixelSize), _selectedColor));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desenhar na Imagem'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveImage,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colorList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colorList[index];
                    });
                  },
                  child: Container(
                    width: 50,
                    color: colorList[index],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onPanUpdate: (details) {
                  _drawPoint(details.globalPosition);
                },
                onPanEnd: (details) {
                  points.add(PointData(Offset.zero, _selectedColor));
                },
                child: _image != null
                    ? CustomPaint(
                        painter: ImagePainter(_image, points, pixelSize),
                        size: Size(_image!.width.toDouble(), _image!.height.toDouble()),
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveImage() async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(_image!.width.toDouble(), _image!.height.toDouble());
      ImagePainter(_image, points, pixelSize).paint(canvas, size);
      final picture = recorder.endRecording();
      final img = await picture.toImage(size.width.toInt(), size.height.toInt());

      // Criar uma nova imagem onde os pixels são desenhados com as cores corretas
      final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List byteList = Uint8List.view(pngBytes!.buffer);
      for (var i = 0; i < points.length; i++) {
        if (points[i].offset != Offset.zero) {
          final pixelIndex = (points[i].offset.dx + points[i].offset.dy * size.width).toInt();
          if (pixelIndex * 4 + 3 < byteList.length) { // Verificação de limite
            final pixelColor = points[i].color;
            byteList[pixelIndex * 4] = pixelColor.red;
            byteList[pixelIndex * 4 + 1] = pixelColor.green;
            byteList[pixelIndex * 4 + 2] = pixelColor.blue;
            byteList[pixelIndex * 4 + 3] = pixelColor.alpha;
          }
        }
      }

      final result = await ImageGallerySaver.saveImage(byteList);
      print(result);
    } catch (e) {
      print(e);
    }
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image? image;
  final List<PointData> points;
  final double pixelSize;

  ImagePainter(this.image, this.points, this.pixelSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      canvas.drawImage(image!, Offset.zero, Paint());
    }

    for (var pointData in points) {
      final paint = Paint()..color = pointData.color;

      if (pointData.offset != Offset.zero) {
        canvas.drawRect(
          Rect.fromLTWH(pointData.offset.dx, pointData.offset.dy, pixelSize, pixelSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PointData {
  final Offset offset;
  final Color color;

  PointData(this.offset, this.color);
}
