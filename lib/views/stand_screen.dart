import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validafeira/views/camera_screen.dart';
import '../widgets/widget_button_feira.dart';

class StandScreen extends StatefulWidget {
  const StandScreen({Key? key}) : super(key: key);

  @override
  State<StandScreen> createState() => _StandScreenState();
}

class _StandScreenState extends State<StandScreen> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  int _pressedIndex = -1;
  int _pressedCheck = -1;
  String _stand = "";
  String? _standCache;
  List<String> entries = <String>[
    "Feirinha",
    "Arena Sebrae",
    "Espaço Sebrae",
    "Sebrae Inovação",
    "Espaço Expositores",
    "Patrocinador Prata",
    "Entidades",
    "Trilha do Empreendedor",
    "Produtividade",
    "Inovação",
    "Turismo",
    "Inovação",
    "Personalização",
    "Ouvidoria",
    "Guarda Volumes",
    "Credenciamento",
    "PodCast",
    "Mestre de Negócios",
    "Canvas Express",
    "Comece",
    "ICode",
    "Alcance",
    "Espaço Família",
    "Seja",
    "Faça",
    "Rodada de Negócios",
    "Rodada de Crédito",
  ];
  @override
  void initState() {
    super.initState();
    _loadStandCache();
  }

  Future<void> _loadStandCache() async {
    _standCache = await asyncPrefs.getString('nameStand');

    if (_standCache != null) {
      int i = entries.indexOf(_standCache!);

      if (i >= 0) {
        setState(() {
          _stand = entries[i];
          _pressedCheck = i;
        });
      }
    }
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
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(top: 80, bottom: 40, right: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 0.0),
                    child: ButtonFeira(
                        label: "Confimar",
                        onPressed: () => {
                              if (_stand != "")
                                {
                                  if ((_stand == _standCache))
                                    {
                                      Navigator.of(context)
                                          .pushReplacement(_createRoute())
                                    }
                                  else
                                    {_dialogBuilder(context)}
                                }
                              else
                                {
                                  showSnack(
                                      "Selecione um Stand primeiro", context)
                                }
                            }),
                  ),
                ],
              ),
              const Text(
                'Selecione seu STAND',
                style: TextStyle(
                    fontFamily: 'AlegreyaSans',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    backgroundColor: Colors.transparent),
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isPressed = _pressedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _pressedIndex = index;
                      });

                      Future.delayed(const Duration(milliseconds: 200), () {
                        setState(() {
                          _pressedIndex = -1;
                          _stand = entries[index];
                          _pressedCheck = index;
                        });
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isPressed
                            ? [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset:
                                      const Offset(0, 2), // Sombra mais próxima
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 4,
                                  offset: const Offset(
                                      6, 10), // Sombra mais distante
                                ),
                              ],
                      ),
                      transform: isPressed
                          ? Matrix4.translationValues(
                              0, 5, 0) // Desce o container
                          : Matrix4.translationValues(
                              0, 0, 0), // Posição original
                      child: ListTile(
                          title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 0),
                          Container(
                            margin: EdgeInsets.only(left: 50),
                            child: Text(
                              entries[index],
                              style: const TextStyle(
                                fontFamily: 'AlegreyaSans',
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: _pressedCheck == index ? 1.0 : 0.0,
                              child: Icon(Icons.check_circle_rounded,
                                  color: Colors.green[700]))
                        ],
                      )),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                        height: 26,
                        indent: 40,
                        endIndent: 40,
                        color: Colors.black38),
              ))
            ],
          )),
    );
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

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: const TextStyle(
            fontFamily: 'AlegreyaSans',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          title: const Text('Confirme seu STAND'),
          content: Text(
              'O stand na qual você selecionou é $_stand.\n'
              'Tem certeza que você está localizado em $_stand',
              style: const TextStyle(
                fontFamily: 'AlegreyaSans',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              )),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Cancelar',
                style: const TextStyle(
                  fontFamily: 'AlegreyaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Confirmar',
                style: const TextStyle(
                  fontFamily: 'AlegreyaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                await asyncPrefs.setInt('codEspaco', 10);
                await asyncPrefs.remove('nameStand');
                await asyncPrefs.setString('nameStand', _stand);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(_createRoute());
              },
            ),
          ],
        );
      },
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const CameraScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin =
            Offset(1.0, 0.0); 
        const end = Offset.zero;  
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(
              tween),  
          child: child,
        );
      },
    );
  }
}
