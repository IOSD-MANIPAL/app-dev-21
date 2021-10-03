
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowCase extends StatelessWidget {
  final Widget child;
  final String description;
  final GlobalKey globalKey;

  // ignore: use_key_in_widget_constructors
  const CustomShowCase(
      {@required this.child,
      @required this.description,
      @required this.globalKey});

  @override
  Widget build(BuildContext context) {
    return Showcase(
      child: child,
      key: globalKey,
      description: description,
      showcaseBackgroundColor: ThemeColor.maroon,
      descTextStyle: GoogleFonts.poppins(color: Colors.white),
      contentPadding: const EdgeInsets.all(8),
      shapeBorder: const StadiumBorder(),
      showArrow: true,
    );
  }
}