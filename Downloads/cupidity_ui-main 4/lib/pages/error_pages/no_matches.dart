import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';

class NoMatches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: SizedBox()),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.02),
          height: h * 0.5,
          child: SvgPicture.asset("assets/peopleSearch.svg"),
        ),
        Expanded(child: SizedBox()),
        Container(
          margin: EdgeInsets.only(
              left: w * 0.1, right: w * 0.1, top: h * 0.05, bottom: h * 0.005),
          child: Text(
            "Sorry!",
            style: GoogleFonts.lato(
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
            "No matches found in your record 🙁",
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
        Expanded(child: SizedBox()),
        actionButton(h, w)
      ],
    ));
  }

  Container actionButton(double h, double w) {
    return Container(
      height: h / 16,
      width: w / 2,
      margin: EdgeInsets.only(left: w * 0.1, right: w * 0.1, bottom: h * 0.1),
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
        onPressed: () {},
        child: Text(
          "START LIKING",
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
    );
  }
}
