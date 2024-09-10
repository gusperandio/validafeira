import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validafeira/controllers/fetch_api.dart';
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
  final TextEditingController _emailValue = TextEditingController();
  final TextEditingController _passValue = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
    _emailValue.dispose();
    _passValue.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void navigateToEventScreen(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => EventScreen()));
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  void validateFields(BuildContext context) async {
    if (_emailValue.text.isEmpty && _passValue.text.isEmpty) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
      showSnack("Informe seus dados!", context);
      return;
    } else if (_emailValue.text.isEmpty) {
      showSnack("Informe o email", context);
      FocusScope.of(context).requestFocus(_emailFocusNode);
      return;
    } else if (_passValue.text.isEmpty) {
      showSnack("Informe a senha", context);
      FocusScope.of(context).requestFocus(_passwordFocusNode);
      return;
    } else if (validateEmail(_emailValue.text) != null) {
      showSnack("E-mail inválido!", context);
      FocusScope.of(context).requestFocus(_emailFocusNode);
      return;
    }

    LoginResponse authorization =
        await fetchLogin(_emailValue.text, _passValue.text);

    if (!authorization.success) {
      showSnack(authorization.message, context);
      return;
    }

    navigateToEventScreen(context);
  }

  void showSnack(String text, context) {
    final snackBar = SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            fontFamily: 'AlegreyaSans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        action: SnackBarAction(
          label: 'Fechar',
          onPressed: () {},
          backgroundColor: Colors.black45,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.red[400]);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                      child: FieldFeira(
                        label: "E-mail",
                        pass: false,
                        controller: _emailValue,
                        focusNode: _emailFocusNode,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 0.0),
                      child: FieldFeira(
                        label: "Senha",
                        pass: true,
                        controller: _passValue,
                        focusNode: _passwordFocusNode,
                      ),
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
                            validateFields(context);
                          }),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
