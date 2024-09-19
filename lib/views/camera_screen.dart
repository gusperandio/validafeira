import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:validasebrae/cache/load_lote_presenca.dart';
import 'package:validasebrae/controllers/fetch_api.dart';
import 'package:validasebrae/views/stand_screen.dart';
import 'package:validasebrae/widgets/widget_simple_button.dart';
import 'package:validasebrae/widgets/widget_toast.dart';
import '../widgets/widget_button_feira.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  String? _standCache;
  String? codDisp = dotenv.env['DISP_COD'];
  final CustomToastWidget _toastSuccess = CustomToastWidget(
    title: 'Beleza!!!',
    description: 'Presenças registradas com sucesso.',
    typeNow: ToastificationType.success,
    styleNow: ToastificationStyle.flatColored,
    iconNow: Icons.check_circle_outline_rounded,
    generalColor: Colors.black87,
  );

  final CustomToastWidget _toastWarning = CustomToastWidget(
    title: 'Ops!',
    description:
        'Estamos com um pouco de fila, logo vamos registrar esta presença. Continue!',
    typeNow: ToastificationType.warning,
    styleNow: ToastificationStyle.fillColored,
    iconNow: Icons.warning_rounded,
    generalColor: Colors.white,
  );

  final CustomToastWidget _toastCamera = CustomToastWidget(
    title: 'Que triste!',
    description:
        'Infelizmente não vai ser possível ler o QRCode sem o acesso a sua camêra',
    typeNow: ToastificationType.info,
    styleNow: ToastificationStyle.fillColored,
    iconNow: Icons.sentiment_dissatisfied_rounded,
    generalColor: Colors.white,
  );

  final CustomToastWidget _toastError = CustomToastWidget(
    title: 'Eita!',
    description: 'Tivemos algum problema, leia o QRCode novamente!',
    typeNow: ToastificationType.error,
    styleNow: ToastificationStyle.fillColored,
    iconNow: Icons.error,
    generalColor: Colors.white,
  );

  late AnimationController _controller;
  CameraController? _cameraController;
  bool _isCameraOpen = false;
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
    _loadStandCache();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOpen = !_isCameraOpen;
    });
  }

  Future<void> _loadStandCache() async {
    String? _cache = await asyncPrefs.getString('nameStand');

    if (_cache != null) {
      setState(() {
        _standCache = _cache;
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      if (!await Permission.camera.request().isGranted) {
        _showToast("camera");
        return;
      }
    }

    await readQRCode();
    return;
  }

  CustomToastWidget? toastWidget;
  readQRCode() async {
    try {
      String ticket = "";
      bool resp;
      String code = await FlutterBarcodeScanner.scanBarcode(
          "#DC3545", "Cancelar", false, ScanMode.QR);
      ticket = code != '-1' ? code : 'Não validado';

      if (code != '-1') {
        int codEspaco = await asyncPrefs.getInt('codStand') ?? 0;
        int codAgente = await asyncPrefs.getInt('codAgente') ?? 467;

        var actual = PresentRequest(
            codDisponibilizacao: int.parse(codDisp!),
            codEspaco: codEspaco,
            qrCode: code,
            codAgente: codAgente);

        ListPresent listPresentToUse = ListPresent();
        List<PresentRequest> lotes = await listPresentToUse.getPresents();
        if (lotes.length > 0) {
          lotes.add(actual);
          resp = await fetchPresencaLote(lotes);

          if (resp) {
            await listPresentToUse.deletePresents();
          } else {
            await listPresentToUse.setPresents(actual);
          }
        } else {
          resp = await fetchPresenca(actual);
          if (!resp) await listPresentToUse.setPresents(actual);
        }

        setState(() {
          resp ? _showToast("ok") : _showToast("warning");
        });

        _toggleCamera();
      }
    } catch (e) {
      _showToast("error");
    }
  }

  void _showToast(String ticket) {
    setState(() {
      toastWidget = null;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        switch (ticket) {
          case 'ok':
            toastWidget = _toastSuccess;
            break;
          case 'warning':
            toastWidget = _toastWarning;
            break;
          case 'error':
            toastWidget = _toastError;
            break;
          case 'camera':
            toastWidget = _toastCamera;
            break;
          default:
            toastWidget = null;
        }
      });
    });
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 0.0),
                  child: ButtonFeira(
                    label: "Trocar STAND",
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(_createRoute()),
                    },
                  ),
                ),
              ],
            ),
            const Text(
              'Leitura sendo registrada em',
              style: TextStyle(
                  fontFamily: 'AlegreyaSans',
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  backgroundColor: Colors.transparent),
            ),
            Text(
              _standCache ?? "",
              style: const TextStyle(
                  fontFamily: 'AlegreyaSans',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                  backgroundColor: Colors.transparent),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
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
                    ],
                  ),
                  width: 4,
                ),
              ),
              height: 220,
              width: 220,
              child: Padding(
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
                            angle: _controller.value * 2.0 * 3.141592653589793,
                            child: child,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SimpleButton(
              label: "Abrir Câmera",
              onPressed: () async {
                await _requestCameraPermission();
              },
              iconSVG: qrCodeON,
              buttonColor: const Color(0xff188754),
            ),
            if (toastWidget != null) toastWidget!,
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const StandScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
