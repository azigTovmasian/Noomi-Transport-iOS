import 'package:flutter/material.dart';

PreferredSizeWidget appBar(String title, VoidCallback OnPressed) {
  return AppBar(
    elevation: 1,
    backgroundColor: Colors.white,
    centerTitle: true,
    leading: IconButton(
      iconSize: 34,
      icon: Icon(
        color: Color(0xff7CA03E),
        Icons.arrow_back_rounded,
      ),
      onPressed: OnPressed,
    ),
    title: Text(
      title,
      style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: Color(0xff7CA03E)),
    ),
  );
}
