import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validafeira/views/event_screen.dart';
import '../widgets/widget_button_feira.dart';
import '../widgets/widget_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  bool showItem = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, -120),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showItem = true;
        });
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _controller.dispose();
    super.dispose();
  }

  void navigateToEventScreen(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => EventScreen()));
  }

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: _offsetAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  'assets/logo_black.png',
                  width: 350,
                  height: 220,
                ),
              ),
            ),
            Opacity(
                opacity: showItem ? 1.0 : 0.0,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 0.0),
                      child: const FieldFeira(label: "E-mail", pass: false),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 0.0),
                      child: const FieldFeira(label: "Senha", pass: true),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 24),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 0.0),
                      child: ButtonFeira(
                          label: 'Acessar',
                          onPressed: () {
                            navigateToEventScreen(context);
                          }),
                    )
                  ],
                )),
            // DropdownButton
          ],
        ),
      ),
    );
  }
}
