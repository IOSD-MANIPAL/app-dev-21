// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;

import '../../../Constants/colors.dart';
import '../../../match_page/match_page.dart';
import '../../googlesignin.dart';
import '../../verification_code.dart';
import 'name_age_gender.dart';

import '../../webview_controller.dart';

class NewLandingPage extends StatefulWidget {
  const NewLandingPage({Key key}) : super(key: key);

  @override
  _NewLandingPageState createState() => _NewLandingPageState();
}

class _NewLandingPageState extends State<NewLandingPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _validate = false;
  bool phoneNumber = false;
  bool verifying = false;
  bool googleTapped = false;
  String countrycodeString = "+91";
  final options = const LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 1),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 500),

    // Animation duration (default 250)
    showItemDuration: Duration(seconds: 1),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.05,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );

  String finalphone;
  // ignore: missing_return
  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential credential) async {
            Navigator.of(context).pop();
            UserCredential result =
                await _auth.signInWithCredential(credential);
            User user = result.user;
            print(user.providerData);
            if (user != null &&
                user.metadata.creationTime != user.metadata.lastSignInTime) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MatchPage2(
                            newUser: false,
                          )));
            } else if (user != null &&
                user.metadata.creationTime == user.metadata.lastSignInTime) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NameAgeGender()));
            } else {
              print("Error");
            }

            //This callback would get called when verification is done automaticlly
          },
          verificationFailed: (FirebaseAuthException exception) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Please Enter a Valid Phone Number or Sign in with Google",
                  style: GoogleFonts.poppins(),
                ),
              ),
            );
            setState(() {
              verifying = false;
            });
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Verification(
                  forceResendingToken: forceResendingToken,
                  verificationId: verificationId,
                  auth: _auth,
                  phone: phone,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationID) {
            print("Verification ID : " + verificationID);
          });
    } catch (e) {
      print("[ERROR] $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    final elements = [
      cupidityTitle(),
      cupidityTagline(),
      illustrationImage(h),
      buildLetGetStartedText(h, w),
      buildSignInWithGoogle(h, w),
      buildOrText(h, w),
      buildPhoneNumber(h, w),
      buildTosAndPp(h, w),
      phoneNumber ? buildProceedButton(h, w) : const SizedBox(),
    ];
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.light),
    );
    return Scaffold(
      backgroundColor: ThemeColor.white,
      body: SafeArea(
        child: LiveList(
          showItemInterval: const Duration(milliseconds: 50),
          showItemDuration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          reAnimateOnVisibility: false,
          scrollDirection: Axis.vertical,
          itemCount: elements.length,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) =>
                  FadeTransition(
            opacity: Tween<double>(
              begin: 0,
              end: 1,
            ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: elements.elementAt(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget cupidityTitle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: 8,
        ),
        child: Text(
          "Cupidity",
          style: GoogleFonts.pacifico(
            textStyle: GoogleFonts.poppins(
              color: ThemeColor.pinkish,
              fontSize: 60,
              letterSpacing: .5,
            ),
          ),
        ),
      ),
    );
  }

  Widget cupidityTagline() {
    return Center(
      child: Text(
        "Tales Beyond Octaves",
        style: GoogleFonts.pacifico(
          textStyle: GoogleFonts.poppins(
            fontSize: 20,
            color: ThemeColor.notBlack,
          ),
        ),
      ),
    );
  }

  Widget illustrationImage(double h) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24.0,
        ),
        child: SizedBox(
          height: h / 4.44,
          child: SvgPicture.asset('assets/image7.svg'),
        ),
      ),
    );
  }

  Widget buildLetGetStartedText(double h, double w) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          left: w * 0.02,
          right: w * 0.02,
          top: w * 0.02,
        ),
        child: Text(
          "Let's get started!",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
            color: ThemeColor.notBlack,
            fontSize: 28,
            // fontWeight: FontWeight.w600,
          )),
        ),
      ),
    );
  }

  Widget buildPhoneNumber(double h, double w) => Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
        height: h / 16,
        decoration: const BoxDecoration(
          color: Colors.white,
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
        child: phoneNumber == false
            ? continueWithPhoneNumberText(w)
            : phoneNumberTextField(),
      );

  Row phoneNumberTextField() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: FittedBox(
              child: CountryCodePicker(
                textStyle: GoogleFonts.ptMono(
                  decorationStyle: TextDecorationStyle.double,
                  textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      letterSpacing: 0.0,
                      color: ThemeColor.notBlack),
                ),
                onChanged: (countryCode) {
                  setState(() {
                    countrycodeString = countryCode.toString();
                  });
                },
                initialSelection: '+91',
                showCountryOnly: false,
                alignLeft: true,
                hideMainText: true,
                showOnlyCountryWhenClosed: false,
              ),
            ),
          ),
          const Flexible(
            flex: 1,
            child: Icon(
              Icons.arrow_drop_down_rounded,
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                autofocus: true,
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                cursorColor: ThemeColor.pinkish2,
                cursorRadius: const Radius.circular(8),
                style: GoogleFonts.ptMono(
                  textStyle: const TextStyle(
                      fontSize: 18,
                      letterSpacing: 1,
                      color: ThemeColor.notBlack),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter phone number",
                  hintStyle: GoogleFonts.raleway(
                    decorationStyle: TextDecorationStyle.double,
                    textStyle: GoogleFonts.poppins(
                        fontSize: 18,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400,
                        color: ThemeColor.notBlack),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  TextButton continueWithPhoneNumberText(double w) => TextButton(
        onPressed: () {
          setState(() {
            phoneNumber = true;
          });
        },
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 12,
                right: w * 0.04,
              ),
              child: const Icon(
                Icons.phone,
                color: ThemeColor.notBlack,
                size: kMinInteractiveDimensionCupertino * 0.6,
              ),
            ),
            Expanded(
              child: Text(
                "Continue with Phone",
                style: GoogleFonts.poppins(
                  decorationStyle: TextDecorationStyle.double,
                  textStyle: GoogleFonts.poppins(
                      fontSize: 18,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      color: ThemeColor.notBlack),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildSignInWithGoogle(double h, double w) => Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: w * 0.04),
        height: h / 16,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColor.shadow,
              spreadRadius: 0,
              blurRadius: 4.68,
              offset: Offset(0, 2.34),
            ),
          ],
        ),
        child: !googleTapped
            ? GestureDetector(
                onTap: signIn,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: w * 0.04,
                      ),
                      child: SvgPicture.asset(
                        'assets/google_icon.svg',
                        height: kMinInteractiveDimensionCupertino * 0.6,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Continue with Google",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            letterSpacing: 0.0,
                            color: ThemeColor.notBlack,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
      );

  void signIn() {
    setState(() {
      googleTapped = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        googleTapped = false;
      });
    });
    signInWithGoogle().then(
      (value) async {
        print(value.metadata.creationTime);
        print(value.metadata.lastSignInTime);
        if (value != null &&
            (value.metadata.lastSignInTime
                    .difference(value.metadata.creationTime) >
                const Duration(seconds: 1))) {
          var responseData;
          var res = json.encode({
            "target_id": value.uid,
          });
          final response = await http.post(
            Uri.parse(
                'https://cupidity-api.herokuapp.com/users/fetchUser/?API_KEY=CUPIDITY'),
            body: res,
            headers: {"Content-Type": "application/json"},
          );
          responseData = json.decode(response.body);
          print(responseData);

          if (responseData == null) {
            Navigator.of(context).push(_createRoute(const NameAgeGender()));
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                _createRoute(
                  const MatchPage2(
                    newUser: false,
                  ),
                ),
                (route) => false);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MatchPage2(
                newUser: false,
              ),
            ),
          );
        } else if (value != null &&
            (value.metadata.lastSignInTime
                    .difference(value.metadata.creationTime) <
                const Duration(seconds: 1))) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NameAgeGender(),
            ),
          );
        }
      },
    );
  }

  Widget buildProceedButton(double h, double w) {
    if (verifying != true) {
      return Center(
        child: Container(
          height: h / 16,
          width: w / 2,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: ThemeColor.pinkish2.withOpacity(0.9),
            borderRadius: const BorderRadius.all(
              Radius.circular(28.0),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffEA77BB).withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 2.34),
              )
            ],
          ),
          child: InkWell(
            splashColor: ThemeColor.maroon,
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              setState(() {
                verifying = true;
              });
              finalphone = "$countrycodeString${_phoneNumberController.text}";
          
              setState(() {
                finalphone.length >= 10 || finalphone.length <= 15
                    ? _validate = true
                    : _validate = false;
              });
              if (_validate) {
                loginUser(finalphone, context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                                        content: Text("Phone number has to have 10 digits"),
                  
                  ),
                );
              }
            },
            child: Center(
              child: Text(
                'Continue',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  textStyle: GoogleFonts.poppins(
                    fontSize: 20,
                    letterSpacing: 0.5,
                    color: Colors.white,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        ),
      );
    }
  }

  Widget buildTosAndPp(double h, double w) {
    return Container(
      margin: EdgeInsets.only(
          left: w * 0.02, right: w * 0.02, bottom: w * 0.01, top: w * 0.01),
      child: RichText(
        text: TextSpan(
          text: '',
          children: <TextSpan>[
            TextSpan(
              text: 'By continuing you agree to our ',
              style: GoogleFonts.poppins(
                textStyle: GoogleFonts.poppins(
                    color: ThemeColor.notBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            TextSpan(
              text: 'terms of service',
              style: GoogleFonts.poppins(
                textStyle: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SafeArea(
                          child: MyWebView(
                            selectedUrl:
                                "https://cupidity.co.in/p&tos.html#TAC",
                          ),
                        ),
                      ),
                    ),
              // style: new GoogleFonts.poppins(fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: ' and ',
              style: GoogleFonts.poppins(
                textStyle: GoogleFonts.poppins(
                    color: ThemeColor.notBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            TextSpan(
              text: 'privacy policy',
              style: GoogleFonts.poppins(
                  textStyle: GoogleFonts.poppins(
                      color: Colors.blue.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SafeArea(
                          child: MyWebView(
                            selectedUrl: "https://cupidity.co.in/p&tos.html",
                          ),
                        ))),
              //  style: new GoogleFonts.poppins(fontWeight: FontWeight.bold)
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildOrText(double h, double w) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: w * 0.02),
        child: Text(
          "Or",
          style: GoogleFonts.poppins(
              textStyle: GoogleFonts.poppins(
                  color: ThemeColor.notBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
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
}
