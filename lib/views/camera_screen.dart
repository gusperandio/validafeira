import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/widget_button_feira.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
            margin: const EdgeInsets.only(left: 0),
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
            child: ButtonFeira(
                label: "Trocar STAND",
                onPressed: () => {Navigator.pop(context)})),
        toolbarHeight: 140,
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
          child: Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(
                    horizontal: 85.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              )
            ],
          ))),
    );
  }
}
