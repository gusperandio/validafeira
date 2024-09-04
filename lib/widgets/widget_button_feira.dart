import 'package:flutter/material.dart';

class ButtonFeira extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ButtonFeira({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.skewX(-0.4),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 239, 68, 72),
              Color.fromARGB(255, 5, 36, 163),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 1.0],
            transform: GradientRotation(-40 * 3.1416 / 180),
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            side: const BorderSide(
              color: Colors.black54,
              width: 2,
            ),
          ),
          child: Transform(
            transform: Matrix4.skewX(0.4),
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 8, top: 2, right: 16, bottom: 2),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'AlegreyaSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
