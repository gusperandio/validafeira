import 'package:flutter/material.dart';
import 'package:validafeira/views/login_screen.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async{
  //WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ValidaFeira());
}

class ValidaFeira extends StatelessWidget {
  const ValidaFeira({super.key});
 
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
