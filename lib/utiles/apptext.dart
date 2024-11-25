import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  var text;
  final double size;
  final Color color;
  final FontWeight weight;
  final TextAlign align;

  AppText({
    Key? key,
    required this.text,
    required this.size,
    required this.color,
    required this.weight,
    this.align = TextAlign.start, // Default alignment
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align, 
      style: TextStyle(
        fontWeight: weight,
        color: color,
        fontSize: size,
      ),
    );
  }
}
