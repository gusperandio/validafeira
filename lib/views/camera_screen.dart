import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:validafeira/widgets/widget_simple_button.dart';
import '../widgets/widget_button_feira.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showCamera = true;
  SvgPicture qrCodeON = SvgPicture.asset(
    'assets/svg/qrcode-on.svg',
    height: 32,
    width: 32,
  );

  SvgPicture qrCodeOFF = SvgPicture.asset(
    'assets/svg/qrcode-off.svg',
    height: 32,
    width: 32,
  );

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
      _showCamera = !_showCamera;
    });
  }

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
          backgroundColor: const Color(0xfff4f7fe),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 140),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: const GradientBoxBorder(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff001ead),
                            Color(0xfffeb47d),
                            Color(0xff00f3bb),
                            Color(0xffe85aea),
                            Color(0xff2f47ff),
                            Color(0xff00bbff),
                            Color(0xffffed5d),
                            Color(0xffff415a),
                            Color(0xffff415a),
                          ],
                        ),
                        width: 4,
                      ),
                    ),
                    height: 220,
                    width: 220,
                    child: _showCamera
                        ? Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage("assets/qrcode.png"),
                                  fit: BoxFit.contain,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedBuilder(
                                    animation: _controller,
                                    child: Image.asset(
                                      'assets/logo_catavento.png',
                                      width: 70,
                                      height: 70,
                                    ),
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _controller.value *
                                            2.0 *
                                            3.141592653589793,
                                        child: child,
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(height: 20), //COLOCAR A CAMERA AQUI
                  ),
                  const SizedBox(height: 20),
                  _showCamera
                      ? SimpleButton(
                          label: "Ler QRCode",
                          onPressed: _handleTap,
                          iconSVG: qrCodeON,
                          buttonColor: const Color(0xff188754))
                      : SimpleButton(
                          label: "Fechar Camêra",
                          onPressed: _handleTap,
                          iconSVG: qrCodeOFF,
                          buttonColor: const Color(0xffdc3546))
                ],
              ),
            )));
  }
}
