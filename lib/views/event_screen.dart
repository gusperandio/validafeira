import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validasebrae/views/stand_screen.dart';
import '../widgets/widget_button_feira.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isClicked = false;
  
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isClicked = !_isClicked;
    });
  }

  void navigateToStandScreen(BuildContext context) async {
    await asyncPrefs.setInt('codDisponibilizacao', 10);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => StandScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backgroundBody.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Selecione um evento",
                style: const TextStyle(
                  fontFamily: 'AlegreyaSans',
                  fontSize: 32,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: _handleTap,
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _controller,
                                      child: Image.asset(
                                        'assets/logo_catavento.png',
                                        width: 40,
                                        height: 40,
                                      ),
                                      builder: (context, child) {
                                        return Transform.rotate(
                                          angle: _controller.value *
                                              2.0 *
                                              3.141592653589793,
                                          child: child,
                                        );
                                      },
                                    ),
                                    const Text("Feira do empreendedor",
                                        style: TextStyle(
                                            fontFamily: 'AlegreyaSans',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    _isClicked
                                        ? SvgPicture.asset(
                                            'assets/svg/check.svg',
                                            height: 32,
                                            width: 32,
                                          )
                                        : const SizedBox(
                                            height: 32,
                                            width: 32,
                                          ),
                                  ])))),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Opacity(
                opacity: _isClicked ? 1.0 : 0.0,
                child: ButtonFeira(
                    label: 'Continuar',
                    onPressed: () {
                      navigateToStandScreen(context);
                    }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
