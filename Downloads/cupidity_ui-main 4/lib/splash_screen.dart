import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'models/Artist.dart';
import 'pages/error_pages/no_internet.dart';
import 'pages/match_page/match_page.dart';
import 'pages/registration_process/new_registration_process/pages/landing_page.dart';

import 'global_variables.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  bool isConnectedToInternet = true;
  Future checkConnectivity() async {
    var connectionStatus = await Connectivity().checkConnectivity();
    if (connectionStatus == ConnectivityResult.none) {
      setState(() {
        isConnectedToInternet = false;
      });
    } else {
      setState(() {
        isConnectedToInternet = true;
      });
    }
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/artists/artists.json');
    final data = await json.decode(response);
    if (mounted) {
      setState(() {
        var artistData = data["items"];
        for (var artist in artistData) {
          // print(artist);
          var art = Artist(
            genre: artist["genre"],
            image: artist["image"],
            name: artist["name"],
            popularity: artist["popularity"],
            uri: artist["uri"],
          );
          artists.add(art);
        }
        print(artists.length);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    readJson();
    checkConnectivity().then((value) {
      if (isConnectedToInternet == true) {
        _checkSession().then((status) {
          if (status) {
            _navigate();
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(context,
            _createRoute(NoInternetConnectionPage()), (route) => false);
      }
    });
  }

  Future<bool> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
    return true;
  }

  void _navigate() async {
    final User user = auth.currentUser;
    var responseData;
    print(user != null);
    print(user);
    if (user != null) {
      var res = json.encode({
        "target_id": user.uid,
      });
      final response = await http.post(
        Uri.parse(
            'https://cupidity-api.herokuapp.com/users/fetchUser/?API_KEY=CUPIDITY'),
        body: res,
        headers: {"Content-Type": "application/json"},
      );
      responseData = json.decode(response.body);
      // print(responseData);
    }

    if (user == null || responseData == null) {
      Navigator.of(context).pushAndRemoveUntil(
          _createRoute(const NewLandingPage()), (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          _createRoute(const MatchPage2(newUser: false,)), (route) => false);
    }
  }

  Route _createRoute(var routeName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => routeName,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color.fromRGBO(254, 79, 133, 1),
        // rgb(254, 79, 133)
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Color.fromRGBO(254, 79, 133, 1),
            Color.fromRGBO(230, 122, 102, 1),
          ])),
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/logo.svg',
              color: Colors.white,
            ),
          ),
        ],
      ),
    ));
  }
}
