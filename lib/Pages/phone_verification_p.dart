// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:noomi_transport_app/Pages/signin_p.dart';
// import 'package:noomi_transport_app/Widgets/no_internet_w.dart';
// import 'package:provider/provider.dart';
// import '../Provider/connectivity_prov.dart';
// import '../Provider/phone_prov.dart';
// import '../Widgets/pincode_fields_w.dart';

// class PhoneVerificationP extends StatefulWidget {
//   const PhoneVerificationP({Key? key}) : super(key: key);

//   @override
//   State<PhoneVerificationP> createState() => _PhoneVerificationPState();
// }

// class _PhoneVerificationPState extends State<PhoneVerificationP> {
//   Timer? _timer;
//   int _resendCooldown = 0;

//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel the timer when the widget is disposed
//     super.dispose();
//   }

//   void startResendCooldown() {
//     const int cooldownDuration = 60; // cooldown duration in seconds
//     setState(() {
//       _resendCooldown = cooldownDuration;
//     });
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_resendCooldown > 0) {
//           _resendCooldown--;
//         } else {
//           _timer?.cancel(); // Cancel the timer when the cooldown is over
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     PhoneProv phoneProv = Provider.of<PhoneProv>(context, listen: false);
//     PhoneProv notifiedPhoneProv = Provider.of<PhoneProv>(context, listen: true);
//     ConnectivityProv connectivity =
//         Provider.of<ConnectivityProv>(context, listen: true);

//     return WillPopScope(
//       onWillPop: () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => SignInP()),
//         );
//         return Future.value(false);
//       },
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Color(0xff7CA03E),
//             title: Text(
//               'Phone Number Verification',
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             leading: IconButton(
//               iconSize: 30,
//               icon: Icon(
//                 color: Color.fromARGB(255, 232, 233, 231),
//                 Icons.arrow_back_rounded,
//               ),
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => SignInP()),
//                 );
//               },
//             ),
//             centerTitle: true,
//             elevation: 2,
//           ),
//           body: Visibility(
//             replacement: NoInternetW(),
//             visible: connectivity.isThereInternet,
//             child: Container(
//               width: width,
//               height: height - AppBar().preferredSize.height,
//               child: ListView(
//                 children: [
//                   Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(top: height * 0.05),
//                         child: Center(
//                           child: Container(
//                             width: width,
//                             child: Text(
//                               'Confirm your Code',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.w700),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: height * 0.05,
//                             bottom: height * 0.05,
//                             left: 10,
//                             right: 10),
//                         child: Container(
//                           width: width,
//                           child: Text(
//                             'This code helps keep your account safe and secure.',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xff4B4E45)),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             left: width * 0.1, right: width * 0.1),
//                         child: PinCodeFieldsW(),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                           left: width * 0.4,
//                           right: width * 0.4,
//                           top: height * 0.1,
//                         ),
//                         child: InkWell(
//                           child: Text(
//                             'Resend',
//                             style: TextStyle(
//                               decoration: TextDecoration.underline,
//                               color: _resendCooldown > 0 ? Colors.grey : Color(0xff7CA03E),
//                               fontSize: 18,
//                             ),
//                           ),
//                           onTap: _resendCooldown == 0
//                               ? () {
//                                   startResendCooldown();
//                                 }
//                               : null,
//                         ),
//                       ),
//                       if (_resendCooldown > 0)
//                         Text(
//                           'Resend after: $_resendCooldown seconds',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           floatingActionButton: Padding(
//             padding: const EdgeInsets.only(left: 25),
//             child: Container(
//             width: width,
//             margin: EdgeInsets.all(16),
//             child: FloatingActionButton.extended(
//               onPressed: notifiedPhoneProv.enteredPinCode.length == 6
//                   ? () async {
//               phoneProv.signInWithPhoneNumber(context);
//             }
//                   : null,
//               backgroundColor: notifiedPhoneProv.enteredPinCode.length == 6
//                   ? Color(0xff7CA03E)
//                   : Color.fromARGB(255, 142, 142, 136),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               label: Text(
//                 'CONTINUE',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ),
//           ),
//         ),
//       ),
//     );
//   }
// }
