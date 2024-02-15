import 'package:flutter/material.dart';

Widget TripDetailStatusW(
    double width, Color color, String title, bool state, Color fontcolors) {
  return Visibility(
    visible: state,
      child: Container(
        width: width,
        height: 25,
        decoration: BoxDecoration(
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: fontcolors,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
  );
}
