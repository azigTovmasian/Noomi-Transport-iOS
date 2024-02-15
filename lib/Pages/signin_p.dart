import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noomi_transport_app/Pages/my_trips_p.dart';
import 'package:noomi_transport_app/Widgets/no_internet_w.dart';
import 'package:provider/provider.dart';
import '../Provider/connectivity_prov.dart';
import '../Provider/phone_prov.dart';
import '../Widgets/button_w.dart';
import '../Widgets/progress_indicator_w.dart';

class SignInP extends StatefulWidget {
  const SignInP({super.key});

  @override
  State<SignInP> createState() => _SignInPState();
}

class _SignInPState extends State<SignInP> {
  bool isVerifyPressed = false;
  bool _obscureText = true;
  bool _isEmailValid = false, _isLoading = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> verifyEmailAndPassword(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final phoneProvider = Provider.of<PhoneProv>(context, listen: false);

    // Regular expression to check email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (email.isNotEmpty && emailRegex.hasMatch(email) && password.isNotEmpty) {
      setState(() {
        _isEmailValid = true;
      });
      final isPhoneNumberExists =
          await phoneProvider.checkPhoneNumberExistence(email);
      if (isPhoneNumberExists) {
        final isAccountActive = await phoneProvider.validateAccount(email);
        if (isAccountActive) {
          await phoneProvider.signIn(
              email: _emailController.text, password: _passwordController.text);
          if (phoneProvider.isSignedIn) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyTripsP()),
            );
          } else {
            setState(() {
              _isLoading = false;
            });
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Password Validation'),
                content: Text('Your entered password is not correct.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Color(0xff7CA03E)),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Account Not Activated'),
              content: Text('Your account is not activated.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Color(0xff7CA03E)),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Email Address Not Found'),
            content: Text('Your email does not exist in the Noomi system.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Color(0xff7CA03E)),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      setState(() {
        _isEmailValid = true;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Input'),
          content: Text('Please enter a valid email.\n(example@gmail.com)'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xff7CA03E)),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    PhoneProv notifiedPhoneVerificationProv =
        Provider.of<PhoneProv>(context, listen: true);
    ConnectivityProv connectivity =
        Provider.of<ConnectivityProv>(context, listen: true);
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            bool confirmExit = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Do you want to exit Noomi App?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'No',
                      style: TextStyle(color: Color(0xff7CA03E)),
                    ),
                  ),
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Color(0xff7CA03E)),
                    ),
                  ),
                ],
              ),
            );
            if (confirmExit == true) {
              return true;
            } else {
              return false;
            }
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Stack(
              children: <Widget>[
                Scaffold(
                  body: Visibility(
                    replacement: NoInternetW(),
                    visible: connectivity.isThereInternet,
                    child: Container(
                      height: height,
                      width: width,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Container(
                            width: width * 0.3,
                            height: height * 0.003,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: height * 0.02,
                              right: height * 0.02,
                              bottom: height * 0.03,
                              top: height * 0.04,
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(255, 214, 219, 206),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(255, 214, 219, 206),
                                  ),
                                ),
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              cursorColor: Color(0xff7CA03E),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: height * 0.02,
                              right: height * 0.02,
                              bottom: height * 0.03,
                              top: height * 0.02,
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(255, 214, 219, 206),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(255, 214, 219, 206),
                                  ),
                                ),
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(color: Colors.grey),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              cursorColor: Color(0xff7CA03E),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          CustomButton(
                            buttonTitle: 'SIGN IN',
                            buttonColor: Colors.white,
                            height: height * 0.05,
                            width: width * 0.55,
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });

                              await verifyEmailAndPassword(context);
                            },
                            fontSize: 16,
                            fontColor: Color(0xff7CA03E),
                          ),
                          SizedBox(
                            height: height * 0.1,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: notifiedPhoneVerificationProv.isVreifying,
                  child: Container(
                    color: Colors.transparent.withOpacity(0.7),
                    child: Center(child: ProgressIndicatorW()),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: Container(
            color: Colors.transparent.withOpacity(0.7),
            child: Center(child: ProgressIndicatorW()),
          ),
        ),
      ],
    );
  }
}

String formatPhoneNumber(String number) {
  if (number.length < 3) {
    return number;
  } else if (number.length < 6) {
    return '(${number.substring(0, 3)}) ${number.substring(3)}';
  } else if (number.length < 10) {
    return '(${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6)}';
  } else {
    return '(${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6, 10)}';
  }
}
