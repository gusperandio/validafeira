import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final SvgPicture iconSVG;
  final Color buttonColor;

  const SimpleButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.iconSVG,
      required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shadowColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'AlegreyaSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                iconSVG
              ]),
            )));
  }
}
