import 'package:flutter/material.dart';

Future<dynamic> PopUpDialogW({
  required BuildContext context,
  required String title,
  required String body,
  required void Function() onPressed,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: Text(
              'OK',
              style: TextStyle(
                color: Color(0xff7CA03E),
              ),
            ),
          ),
        ],
      );
    },
  );
}
