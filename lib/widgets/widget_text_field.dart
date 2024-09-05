import 'package:flutter/material.dart';

class FieldFeira extends StatelessWidget {
  final String label;
  final bool pass;

  const FieldFeira({
    Key? key,
    required this.label,
    required this.pass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: pass,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(
          fontFamily: 'AlegreyaSans',
          fontSize: 16,
          fontWeight: FontWeight.bold),
    );
  }
}
