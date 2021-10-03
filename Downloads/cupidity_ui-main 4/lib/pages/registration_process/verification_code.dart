// ignore_for_file: prefer_typing_uninitialized_variables, no_logic_in_create_state, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/match_page/match_page.dart';
import '../Constants/colors.dart';

// import 'package:new_registreation1/pages/registration_process/landing_page.dart';
import 'new_registration_process/pages/name_age_gender.dart';
import 'new_registration_process/pages/landing_page.dart';
// import 'reg_info1.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override

  ///
  /// Checks for secure HTTP Connection.
  ///
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// ignore: must_be_immutable
class Verification extends StatefulWidget {
  var verificationId;
  var forceResendingToken;
  var auth;
  var phone;
  Verification({
    Key key,
    @required this.verificationId,
    @required this.forceResendingToken,
    @required this.auth,
    this.phone,
  }) : super(key: key);
  @override
  _VerificationState createState() => _VerificationState(
        forceResendingToken: forceResendingToken,
        verificationId: verificationId,
        auth: auth,
      );
}

class _VerificationState extends State<Verification> {
  var verificationId;
  var forceResendingToken;
  var auth;

  bool verifying;
  _VerificationState({
    @required this.verificationId,
    @required this.forceResendingToken,
    @required this.auth,
  });
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28.0),
      // ignore: prefer_const_literals_to_create_immutables
      boxShadow: [
        const BoxShadow(
          color: ThemeColor.shadow,
          spreadRadius: 0,
          blurRadius: 4.68,
          offset: Offset(0, 2.34),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: buildBackButton(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildVerificationText(),
              buildEnterVerificationText(phoneNumber: widget.phone),
              buildSvgImage(h),
              buildOTPBox(),
              buildResendOtp(),
              buildVerifyButton(h, w)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBackButton() {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewLandingPage()),
        );
      },
      iconSize: 24,
      icon: const Icon(Icons.arrow_back),
      color: ThemeColor.notBlack,
    );
  }

  Widget buildVerificationText() {
    return Text(
      "Verification Code",
      style: GoogleFonts.raleway(
          textStyle: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: ThemeColor.notBlack)),
    );
  }

  Widget buildEnterVerificationText({phoneNumber}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
        child: RichText(
          text: TextSpan(
            text: "Please Enter the 6-digit Verification code sent to ",
            children: [
              TextSpan(
                  text: "$phoneNumber",
                  style: GoogleFonts.poppins(
                      color: ThemeColor.notBlack, fontSize: 15)),
            ],
            style: GoogleFonts.lato(
              textStyle: GoogleFonts.poppins(
                  fontSize: 18, color: ThemeColor.notBlack, wordSpacing: 2),
            ),
          ),
          // GoogleFonts.poppins(color: Colors.black54, fontSize: 15)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildSvgImage(double h) {
    return SizedBox(
        height: h / 3, child: SvgPicture.asset('assets/image1.svg'));
  }

  Container buildOTPBox() {
    return Container(
      margin: EdgeInsets.all(16),
      child: PinPut(
        fieldsCount: 6,
        //onSubmit: (String pin) => ScaffoldMessenger.of(context).showSnackBar(pin, context),
        focusNode: _pinPutFocusNode,
        controller: _pinPutController,
        submittedFieldDecoration: _pinPutDecoration.copyWith(
          borderRadius: BorderRadius.circular(16.0),
        ),
        selectedFieldDecoration: _pinPutDecoration,
        followingFieldDecoration: _pinPutDecoration.copyWith(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget buildResendOtp() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: "Didn't Recieve Yet? ",
              style: GoogleFonts.raleway(
                textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    color: ThemeColor.notBlack,
                    fontWeight: FontWeight.w400),
              ),
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
                onTap: () {},
                child: Text(
                  "Resend OTP",
                  style: GoogleFonts.raleway(
                    textStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: ThemeColor.notBlack,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          )
        ],
      ),
    );
  }

  getCurrentAppUserData(uid) async {
    var res = json.encode({
      "target_id": uid,
    });
    final response = await http.post(
      Uri.parse(
          "https://cupidity-api.herokuapp.com/users/fetchUser/?API_KEY=CUPIDITY"),
      body: res,
      headers: {"Content-Type": "application/json"},
    );

    var responseData = json.decode(response.body);
    return responseData;
  }

  Widget buildVerifyButton(double h, double w) {
    if (verifying != true) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        height: h / 16,
        width: w / 2.76,
        decoration: const BoxDecoration(
          color: ThemeColor.maroon,
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColor.shadow,
              spreadRadius: 0,
              blurRadius: 4.68,
              offset: Offset(0, 2.34),
            )
          ],
        ),
        child: Center(
            child: GestureDetector(
          onTap: () async {
            try {
              setState(() {
                verifying = true;
              });
              final code = _pinPutController.text.trim();
              AuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: code);

              var result = await auth.signInWithCredential(credential);

              User user = result.user;
              var res = await getCurrentAppUserData(user.uid);
              print(res);
              if (user != null &&
                  user.metadata.lastSignInTime
                          .difference(user.metadata.creationTime) >
                      const Duration(seconds: 3) &&
                  res != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MatchPage2(
                              newUser: false,
                            )));
              } else if (user != null &&
                      user.metadata.lastSignInTime
                              .difference(user.metadata.creationTime) <
                          const Duration(seconds: 3) ||
                  res == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NameAgeGender(),
                  ),
                );
              } else {
                print("Error");
              }
            } catch (e) {
              print(e);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 20, right: 20),
            child: Text('Verify',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                    textStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  // letterSpacing: 0.0,
                  color: Colors.white,
                ))),
          ),
        )),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          color: Colors.pink,
        ),
      );
    }
  }
}
