import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';

class NoProfilesToShowPage extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  NoProfilesToShowPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: SizedBox()),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.02),
          height: h * 0.4,
          child: SvgPicture.asset("assets/NoProfilesToShow.svg"),
        ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.fromLTRB(w * 0.25, 0, w * 0.25, 0),
          child: const LinearProgressIndicator(),
        ),
        Container(
          margin: EdgeInsets.only(
              left: w * 0.1, right: w * 0.1, top: h * 0.05, bottom: h * 0.015),
          child: Text(
            "Take a moment to relax..",
            style: GoogleFonts.lato(
              shadows: [
                BoxShadow(
                  color: ThemeColor.shadow.withOpacity(0.5),
                  spreadRadius: 0.1,
                  blurRadius: 0.1,
                  offset: const Offset(0, 1),
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
            top: h * 0.015,
            bottom: h * 0.025,
          ),
          child: Text(
            "There's someone for everyone 😊",
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
        const Expanded(child: SizedBox()),
      ],
    ));
  }
}
