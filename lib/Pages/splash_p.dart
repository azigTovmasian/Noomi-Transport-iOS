import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noomi_transport_app/Pages/signin_p.dart';
import 'package:provider/provider.dart';
import '../Provider/phone_prov.dart';
import 'my_trips_p.dart';

class SplashP extends StatefulWidget {
  final Completer<void> codeBlockCompleter;
  const SplashP({Key? key, required this.codeBlockCompleter}) : super(key: key);

  @override
  State<SplashP> createState() => _SplashPState();
}

class _SplashPState extends State<SplashP> {
  @override
  void initState() {
    super.initState();
    //  checkAccount(context);
    widget.codeBlockCompleter.future.then((_) {
      navigateToSignIn(Provider.of<PhoneProv>(context, listen: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 228, 230, 164),
                  Color(0xff7CA03E),
                ],
                stops: [0, 1],
                begin: AlignmentDirectional(0, -1),
                end: AlignmentDirectional(0, 1),
              ),
            ),
          ),
          Positioned(
            top: height * 0.15,
            child: Center(
              child: Container(
                height: height * 0.4,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/noomi.png'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigateToSignIn(PhoneProv phoneProv) async {
    await Future.delayed(Duration(seconds: 1), () {
      if (((phoneProv.driverId == 'null' || phoneProv.driverId == '')) ||
          (!phoneProv.isAccountAvailable)) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return SignInP();
        }));
      } else {
        if (phoneProv.isAccountAvailable) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return MyTripsP();
          }));
        }
      }
    });
  }
}
