import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Pages/splash_p.dart';
import 'Provider/cheklist_prov.dart';
import 'Provider/connectivity_prov.dart';
import 'Provider/delivery_info_prov.dart';
import 'Provider/phone_prov.dart';
import 'Provider/profile_prov.dart';
import 'Provider/time_off_request_prov.dart';
import 'Provider/trip_prov.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CheckListProv()),
        ChangeNotifierProvider(create: (context) => TimeOffRequestProv()),
        ChangeNotifierProvider(create: (context) => TripProv()),
        ChangeNotifierProvider(create: (context) => DeliveryInfoProv()),
        ChangeNotifierProvider(create: (context) => ProfileProv()),
        ChangeNotifierProvider(create: (context) => PhoneProv()),
        ChangeNotifierProvider(create: (context) => ConnectivityProv()),
      ],
      child: MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<void> _codeBlockCompleter = Completer<void>();
  @override
  void initState() {
    super.initState();
    getData().then((_) {
      _codeBlockCompleter.complete();
    });
  }

  Future<void> getData() async {
    final phoneProvider = Provider.of<PhoneProv>(context, listen: false);
    await phoneProvider.loadDriverId(context);
    await phoneProvider.checkAccountAvailability();
    await Provider.of<ProfileProv>(context, listen: false).fetchProfileData(
      phoneProvider.driverId ?? "",
    );

    // Simulating an asynchronous task
    await Future.delayed(Duration(microseconds: 500));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!);
        },
        debugShowCheckedModeBanner: false,
        home: SplashP(
          codeBlockCompleter: _codeBlockCompleter,
        ));
  }
}
