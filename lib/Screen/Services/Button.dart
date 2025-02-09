import 'package:flutter/material.dart';
import 'package:notes_app/Screen/Services/Colors.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const Button({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: size.width *.9,
      height: 55,
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: black, width: 1.5),
      ),

      child: TextButton(
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(color: white, fontSize: 18.0)),
      ),
    );
  }
}