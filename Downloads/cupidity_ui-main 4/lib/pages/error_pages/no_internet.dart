import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';
import 'package:new_registreation1/splash_screen.dart';

class NoInternetConnectionPage extends StatefulWidget {
  const NoInternetConnectionPage({Key key}) : super(key: key);

  @override
  _NoInternetConnectionPageState createState() => _NoInternetConnectionPageState();
}

class _NoInternetConnectionPageState extends State<NoInternetConnectionPage> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: h / 2.5,
            child: SvgPicture.asset('assets/no_internet_illustration.svg')),
        Container(
          margin: EdgeInsets.only(
              left: w * 0.1, right: w * 0.1, top: h * 0.05, bottom: h * 0.015),
          child: Text(
            "Oops, No Internet Connection ",
            style: GoogleFonts.lato(
              shadows: [
                BoxShadow(
                  color: ThemeColor.shadow.withOpacity(0.5),
                  spreadRadius: 0.1,
                  blurRadius: 0.1,
                  offset: Offset(0, 1),
                )
              ],
              textStyle: GoogleFonts.poppins(
                  fontSize: 24,
                  color: ThemeColor.notBlack,
                  fontWeight: FontWeight.bold),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: w * 0.1,
            right: w * 0.1,
            top: h * 0.025,
            bottom: h * 0.05,
          ),
          child: Text(
            "Make sure wifi or mobile data is turned on and try again",
            style: GoogleFonts.lato(
              textStyle: GoogleFonts.poppins(
                fontSize: 18,
                letterSpacing: 0.2,
                color: ThemeColor.notBlack,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: h / 16,
          width: w / 2,
          margin:
              EdgeInsets.only(left: w * 0.1, right: w * 0.1, bottom: h * 0.1),
          decoration: BoxDecoration(
            color: ThemeColor.maroon,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: ThemeColor.maroon.withOpacity(0.4),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 2.34),
              )
            ],
          ),
          child: TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SplashScreen(),
                  ),
                  (route) => false);
            },
            child: Text(
              "TRY AGAIN",
              style: GoogleFonts.poppins(
                textStyle: GoogleFonts.poppins(
                  letterSpacing: 0.2,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
