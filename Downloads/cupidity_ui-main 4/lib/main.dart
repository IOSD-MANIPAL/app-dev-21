import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'package:statusbarz/statusbarz.dart';

import 'pages/Constants/colors.dart';

const bool useEmulator = false;
Future<dynamic> _connectToFirebaseEmulator() async {
  final String localHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(
      host: '$localHost:8080', sslEnabled: false, persistenceEnabled: false);
  // FirebaseAuth.instance.useEmulator('https://$localHost:9099');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (useEmulator) {
    await _connectToFirebaseEmulator();
  }

  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatusbarzCapturer(
      child: MaterialApp(
        title: "Cupidity",
        debugShowCheckedModeBanner: false,
        navigatorObservers: [Statusbarz.instance.observer],
        theme: ThemeData(
          primarySwatch: Colors.pink,
          snackBarTheme: SnackBarThemeData(
            backgroundColor: ThemeColor.notBlack,
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            behavior: SnackBarBehavior.floating,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
