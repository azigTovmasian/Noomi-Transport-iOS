import 'package:flutter/material.dart';

class ErrorAndRefreshW extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRefreshPressed;

  const ErrorAndRefreshW(
      {required this.errorMessage, required this.onRefreshPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(left: 50,right: 50),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,color: Colors.black),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: onRefreshPressed,
                child: Text(
                  'Refresh',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                    color: Color(0xff7CA03E),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
