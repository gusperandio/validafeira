import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';

class CustomToastWidget extends StatelessWidget {
  final String title;
  final String description;
  ToastificationType typeNow;
  ToastificationStyle styleNow;
  IconData iconNow;
  Color generalColor;

  CustomToastWidget({
    super.key,
    required this.title,
    required this.description,
    required this.typeNow,
    required this.styleNow,
    required this.iconNow,
    required this.generalColor,
  });

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      toastification.show(
        closeOnClick: true,
        showProgressBar: false,
        context: context,
        type: typeNow,
        style: styleNow,
        autoCloseDuration: const Duration(seconds: 4),
        title: Text(
          title,
          style: TextStyle(
              fontFamily: 'AlegreyaSans',
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: generalColor),
        ),
        description: Text(
          description,
          style: TextStyle(
              fontFamily: 'AlegreyaSans',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: generalColor),
        ),
        icon: Icon(iconNow, color: generalColor),
        showIcon: true,
        alignment: Alignment.bottomCenter,
      );
    });

    return const SizedBox.shrink();
  }
}
