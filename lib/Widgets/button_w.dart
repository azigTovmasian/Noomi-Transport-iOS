import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';

Widget CustomButton({
  double height = 50,
  double fontSize = 18,
  Color fontColor = Colors.white,
  bool enabled=true,
  required String buttonTitle,
  required Color buttonColor,
  required double width,
  required VoidCallback onPressed,
}) {
  return AnimatedButton(
    height: height,
    width: width,
    duration: 20,
    child: Text(
      buttonTitle,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    ),
    color: buttonColor,
    onPressed: onPressed,
    enabled: true,
    shadowDegree: ShadowDegree.light,
  );
}

