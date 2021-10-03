/*
This page collects the data for the persons profile bio.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';
import 'package:new_registreation1/pages/registration_process/new_registration_process/pages/genre_selection.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../global_variables.dart';
import 'components/custom_route.dart';

class Bio extends StatefulWidget {
  const Bio({Key key}) : super(key: key);

  @override
  _BioState createState() => _BioState();
}

class _BioState extends State<Bio> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    bool _isKeyBoardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SlideTransition(
                  position:
                      Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                          .animate(_animationController),
                  child: Column(
                    children: [
                      buildVerificationText(),
                      buildSvgImage(h, w),
                      buildQuickDetailsText(w, h),
                      buildBioTextField(h, w),
                    ],
                  ),
                ),
              ),
            ),
            _isKeyBoardOpen ? const SizedBox() : buildNextButton(h, w),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: BackButton(
        color: ThemeColor.notBlack,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildNextButton(double h, double w) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CircularPercentIndicator(
        radius: 85,
        circularStrokeCap: CircularStrokeCap.round,
        lineWidth: 4.0,
        restartAnimation: false,
        animateFromLastPercent: true,
        animation: true,
        animationDuration: 500,
        percent: (3 / 7),
        center: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
              color: ThemeColor.maroon, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              currentAppUser.bio = bio;
              currentAppUser.printDetails();
              Navigator.push(context,
                  CustomMaterialPageRoute(builder: (context) {
                return const GenreSelection();
              }));
            },
          ),
        ),
        backgroundColor: Colors.grey[400],
        progressColor: Colors.pink,
      ),
    );
  }

  Widget buildBioTextField(double h, double w) {
    return Container(
      constraints: BoxConstraints(maxHeight: h / 6, minHeight: h / 10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: ThemeColor.shadow, width: 1),
          borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: ThemeColor.maroon,
        cursorRadius: const Radius.circular(12),
        maxLines: 5,
        style: GoogleFonts.lato(
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            color: ThemeColor.notBlack,
          ),
        ),
        maxLength: 250,
        onChanged: (value) {
          setState(() {
            bio = value;
            // print(bio);
          });
        },
        decoration: InputDecoration(
          hintStyle: GoogleFonts.lato(
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: ThemeColor.notBlack.withOpacity(.8),
            ),
          ),
          border: InputBorder.none,
          hintText: 'Write Something Fun And Interesting About Yourself!\n',
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );
  }

  Widget buildVerificationText() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "About You",
              style: GoogleFonts.lato(
                  textStyle: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuickDetailsText(double w, double h) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.2, vertical: h * 0.025),
        child: Text(
          "Tell us a bit about yourself!",
          style: GoogleFonts.lato(
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: ThemeColor.notBlack,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildSvgImage(double h, double w) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.025),
        height: h / 3,
        child: SvgPicture.asset('assets/image12.svg'));
  }
}
