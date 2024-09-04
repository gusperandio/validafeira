import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/widget_button_feira.dart';

class StandScreen extends StatefulWidget {
  @override
  _StandScreenState createState() => _StandScreenState();
}

class _StandScreenState extends State<StandScreen>
    with SingleTickerProviderStateMixin { 
  bool _isClicked = false;


 

  void _handleTap() {
    setState(() {
      _isClicked = !_isClicked;
    });
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
            children: [  ],
          ),
        ),
      ),
    ));
  }
}
