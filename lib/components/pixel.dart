import 'package:flutter/material.dart';

class Pixel extends StatefulWidget{
  final Color color;

  const Pixel({super.key, required this.color});
  @override

  State<StatefulWidget> createState() => PixelState(color: color);
}

class PixelState extends State<Pixel> {
  Color color;

  PixelState({
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: sort_child_properties_last
      child: GestureDetector(onTap: () => setState(() {
        color = Colors.black;
        }),
        
      
      ),
      height: 3,
      width: 3,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: color
      ),
    );
  }
}