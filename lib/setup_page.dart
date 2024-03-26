import 'package:flutter/material.dart';
import 'package:trabalho_semestre_flutter/pixel_art_page.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _rowsController;
  late TextEditingController _columnsController;

  @override
  void initState() {
    super.initState();
    _rowsController = TextEditingController();
    _columnsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _rowsController,
                decoration: InputDecoration(
                  labelText: 'Number of rows',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _columnsController,
                decoration: InputDecoration(
                  labelText: 'Number of columns',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PixelArtPage(
                        rows: int.parse(_rowsController.text),
                        columns: int.parse(_columnsController.text),
                      )),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
