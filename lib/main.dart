import 'package:flutter/material.dart';
import 'package:validafeira/views/login_screen.dart';
import 'widgets/widget_button_feira.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  runApp(const ValidaFeira());
}

class ValidaFeira extends StatelessWidget {
  const ValidaFeira({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Valida Feira',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
