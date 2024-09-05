import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:validafeira/views/camera_screen.dart';
import '../widgets/widget_button_feira.dart';
import 'dart:math';

class StandScreen extends StatefulWidget {
  @override
  _StandScreenState createState() => _StandScreenState();
}

enum Groceries { pickles, tomato, lettuce }

Color getRandomColor() {
  List<Color> colors = [
    Color(0xfffeb47d),
    Color(0xff001ead),
    Color(0xff00f3bb),
    Color(0xffe85aea),
    Color(0xff2f47ff),
    Color(0xff00bbff),
    Color(0xffff415a),
    Color.fromARGB(255, 197, 182, 70)
  ];

  int randomNumber = Random().nextInt(colors.length);

  return colors[randomNumber];
}

class _StandScreenState extends State<StandScreen> {
  Groceries? _groceryItem = Groceries.pickles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(left: 0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          child: const Text(
            'SELECIONE O STAND',
            style: const TextStyle(
              fontFamily: 'AlegreyaSans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        toolbarHeight: 140,
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 0),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            child: ButtonFeira(
                label: "Confimar",
                onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraScreen()),
                      )
                    }),
          ),
        ],
        backgroundColor: Color(0xfff4f7fe),
      ),
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backgroundBody.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              RadioListTile<Groceries>(
                value: Groceries.pickles,
                groupValue: _groceryItem,
                onChanged: (Groceries? value) {
                  setState(() {
                    _groceryItem = value;
                  });
                },
                activeColor: getRandomColor(),
                title: const Text(
                  'Pickles',
                  style: const TextStyle(
                    fontFamily: 'AlegreyaSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  "Longer supporting text to demonstrate how the text wraps and how setting 'RadioListTile.isThreeLine = true' aligns the radio to the top vertically with the text.",
                  style: const TextStyle(
                    fontFamily: 'AlegreyaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ),
              RadioListTile<Groceries>(
                value: Groceries.tomato,
                groupValue: _groceryItem,
                activeColor: getRandomColor(),
                onChanged: (Groceries? value) {
                  setState(() {
                    _groceryItem = value;
                  });
                },
                title: const Text('Tomato'),
                subtitle: const Text(
                    'Longer supporting text to demonstrate how the text wraps and the radio is centered vertically with the text.'),
              ),
              RadioListTile<Groceries>(
                value: Groceries.lettuce,
                groupValue: _groceryItem,
                activeColor: getRandomColor(),
                onChanged: (Groceries? value) {
                  setState(() {
                    _groceryItem = value;
                  });
                },
                title: const Text('Lettuce'),
                subtitle: const Text(
                    "Longer supporting text to demonstrate how the text wraps and how setting 'RadioListTile.isThreeLine = true' aligns the radio to the top vertically with the text."),
                isThreeLine: true,
              ),
            ],
          )),
    );
  }
}
