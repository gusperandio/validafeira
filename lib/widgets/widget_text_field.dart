import 'package:flutter/material.dart';

class FieldFeira extends StatelessWidget {
  final String label;
  final bool pass;
  final TextEditingController controller;
  final FocusNode focusNode;
  
  const FieldFeira(
      {super.key,
      required this.label,
      required this.pass,
      required this.controller,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
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
