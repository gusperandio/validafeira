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

int _pressedIndex = -1;
int _pressedCheck = -1;
final List<String> entries = <String>[
  "Feirinha",
  "1",
  "2",
  "3",
  "4",
  "5",
  "5",
  "5",
  "5",
  "15",
  "35",
  "6",
  "7",
  "8",
  "9"
];
final List<int> colorCodes = <int>[600, 500, 100];

class _StandScreenState extends State<StandScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 80, bottom: 40),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 0.0),
                    child: ButtonFeira(
                        label: "Confimar",
                        onPressed: () => {_dialogBuilder(context)}),
                  ),
                ],
              ),
              const Text(
                'Selecione seu STAND',
                style: const TextStyle(
                    fontFamily: 'AlegreyaSans',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    backgroundColor: Colors.transparent),
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isPressed = _pressedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _pressedIndex = index;
                      });

                      // Após um pequeno atraso, reseta o estado para remover o efeito de "afundamento"
                      Future.delayed(const Duration(milliseconds: 200), () {
                        setState(() {
                          _pressedIndex = -1;

                          _pressedCheck =
                              index; // Reseta o índice após a animação
                        });
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isPressed
                            ? [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset:
                                      const Offset(0, 2), // Sombra mais próxima
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 4,
                                  offset: const Offset(
                                      6, 10), // Sombra mais distante
                                ),
                              ],
                      ),
                      transform: isPressed
                          ? Matrix4.translationValues(
                              0, 5, 0) // Desce o container
                          : Matrix4.translationValues(
                              0, 0, 0), // Posição original
                      child: ListTile(
                          title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 0),
                          Container(
                            margin: EdgeInsets.only(left: 50),
                            child: Text(
                              entries[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: _pressedCheck == index ? 1.0 : 0.0,
                              child: Icon(Icons.check_circle_rounded,
                                  color: Colors.green[700]))
                        ],
                      )),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                        height: 26,
                        indent: 40,
                        endIndent: 40,
                        color: Colors.black38),
              ))
            ],
          )),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: const TextStyle(
            fontFamily: 'AlegreyaSans',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          title: const Text('Confirme seu STAND'),
          content: const Text(
              'A dialog is a type of modal window that\n'
              'appears in front of app content to\n'
              'provide critical information, or prompt\n'
              'for a decision to be made.',
              style: const TextStyle(
                fontFamily: 'AlegreyaSans',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              )),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Cancelar',
                style: const TextStyle(
                  fontFamily: 'AlegreyaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Confirmar',
                style: const TextStyle(
                  fontFamily: 'AlegreyaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
