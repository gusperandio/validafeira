import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validasebrae/views/camera_screen.dart';
import 'package:validasebrae/views/event_screen.dart';
import 'package:validasebrae/views/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:validasebrae/views/stand_screen.dart';

Future main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(ValidaSebrae());
}

final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

class ValidaSebrae extends StatelessWidget {
  ValidaSebrae({super.key});

  Future<String> checkPersistence() async {
    if (await asyncPrefs.getBool('logged') == null) {
      return "login";
    }

    if (await asyncPrefs.getInt('codDisponibilizacao') == null) {
      return "disp";
    }

    if (await asyncPrefs.getInt('codStand') == null) {
      return "stand";
    }

    return "jump";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valida Sebrae',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String>(
        future: checkPersistence(),
        builder: (context, snapshot) {
          if (snapshot.data == "disp") return EventScreen();

          if (snapshot.data == "stand") return StandScreen();

          if (snapshot.data == "jump") return CameraScreen();

          return LoginScreen();
        },
      ),
    );
  }
}
