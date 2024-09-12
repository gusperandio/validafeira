import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validafeira/views/camera_screen.dart';
import 'package:validafeira/views/event_screen.dart';
import 'package:validafeira/views/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:validafeira/views/stand_screen.dart';

Future main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(ValidaFeira());
}

final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

class ValidaFeira extends StatelessWidget {
  ValidaFeira({super.key});

  Future<String> checkPersistence() async {
    if (await asyncPrefs.getBool('logged') == null) {
      return "login";
    }

    if (await asyncPrefs.getInt('codDisponibilizacao') == null) {
      return "disp";
    }

    if (await asyncPrefs.getInt('codEspaco') == null) {
      return "stand";
    }

    return "jump";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valida Feira',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String>(
        future: checkPersistence(),
        builder: (context, snapshot) {
          if (snapshot.data == "login" || snapshot.data == null) {
            return LoginScreen();
          } else if (snapshot.data == "disp") {
            return EventScreen();
          } else if (snapshot.data == "stand") {
            return StandScreen();
          } else if (snapshot.data == "jump") {
            return CameraScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
