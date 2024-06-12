import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'import_draw.dart'; // Importa a ImportDrawPage

class ImportPage extends StatefulWidget {
  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  Uint8List? _imageData;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageData = await pickedFile.readAsBytes();
      setState(() {
        _imageData = imageData;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImportDrawPage(imageData: _imageData!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Importar Imagem'),
      ),
      body: Container(
        color: Colors.blue, // Alterando para a cor azul
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Selecionar Imagem'),
              ),
              SizedBox(height: 20),
              _imageData != null
                  ? Image.memory(
                      _imageData!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : Text(
                      'Nenhuma imagem selecionada.',
                      style: TextStyle(color: Colors.white),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImportPage(),
  ));
}
