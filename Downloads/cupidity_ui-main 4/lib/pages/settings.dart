// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../global_variables.dart';
import 'Constants/colors.dart';
import 'registration_process/googlesignin.dart';
// import 'registration_process/landing_page.dart';
import 'registration_process/new_registration_process/pages/landing_page.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:share/share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Color notBlack = Color(0xff2F2E41);

  final Color pinkish = Color(0xffFE3782);

  final Color maroon = Color(0xffDA2753);

  final Color shadow = Color(0xffBDBFC0);


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
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: notBlack,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Settings",
          style: GoogleFonts.lato(
            textStyle: GoogleFonts.poppins(
              color: notBlack,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(w * 0.2, w * 0.04, w * 0.2, w * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/Cupidity_title.svg",
                  height: h * .2,
                ),
              ],
            ),
          ),
          buildTile(
            0,
            Icon(
              Icons.share_rounded,
              size: w * 0.08,
              color: notBlack.withOpacity(0.75),
            ),
            'Invite Friends!',
            'Share this app with your friends!',
            context,
          ),
          buildTile(
            1,
            Icon(
              Icons.bug_report_rounded,
              size: w * 0.08,
              color: notBlack.withOpacity(0.75),
            ),
            'Report a bug',
            "Let us know of any bug you might have encountered",
            context,
          ),
          buildTile(
            2,
            Icon(
              Icons.star_rate_rounded,
              size: w * 0.08,
              color: notBlack.withOpacity(0.75),
            ),
            'Rate this app',
            'A single rating goes a long way to encourage the devs :)',
            context,
          ),
          buildTile(
            3,
            Icon(
              Icons.info_rounded,
              size: w * 0.08,
              color: notBlack.withOpacity(0.75),
            ),
            'About app',
            'Privacy Policy, Terms and Conditions',
            context,
          ),
          buildTile(
            4,
            Icon(
              Icons.logout_rounded,
              size: w * 0.08,
              color: notBlack.withOpacity(0.75),
            ),
            'Logout',
            'Logs out of your account',
            context,
          ),
          buildTile(
            5,
            Icon(
              Icons.delete_forever_rounded,
              size: w * 0.08,
              color: notBlack.withOpacity(0.75),
            ),
            'Delete Account',
            'Deletes your account permanently ',
            context,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: w * 0.05),
            child: Text(
              'Version : 2.0.0',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: GoogleFonts.poppins(
                    color: notBlack.withOpacity(.5),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column buildTile(int index, Icon icon, String title, String subTitle, context) {
    return Column(
      children: [
        ListTile(
          leading: icon,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          onTap: () async {
            switch (index) {
              case 0:
                Share.share("This is a share message to be changed later");
                break;
              case 1:

                // ignore: todo
                //TODO: add code for bugf report here
                launchURL('https://forms.gle/Xhp37HjobNhfk4fL6');
                break;
              case 2:
                // ignore: todo
                //TODO: show in-app review option.

                // if in-app review does'nt work, we can redirect them to our playstore page to rate the app
                break;
              case 3:
                showAboutDialog(
                  context: context,
                  applicationName: "Cupidity",
                  applicationVersion: "2.0.0",
                  applicationIcon: FlutterLogo(),
                  children: [
                    Flex(
                      direction: Axis.vertical,
                      mainAxisSize: MainAxisSize.min,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        ListTile(
                          leading: Icon(Icons.privacy_tip_rounded),
                          visualDensity: VisualDensity.compact,
                          title: Text("Privacy Policy"),
                        ),
                        Divider(),
                        ListTile(
                          visualDensity: VisualDensity.compact,
                          leading: Icon(Icons.chrome_reader_mode),
                          title: Text("Terms and Conditions"),
                        )
                      ],
                    )
                  ],
                );
                break;
              case 4:
                try {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  await signOutGoogle();
                  await auth.signOut();
                  intializeGlobalVariables();
                  if (auth.currentUser == null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewLandingPage(),
                      ),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  print(e.toString());
                  return null;
                }
                break;
              case 5:
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Delete Account"),
                    content:
                        Text("Are you sure you want to delete your account?"),
                    actions: [
                      ActionChip(
                          label: Text('Yes'),
                          onPressed: () async {
                            User user = FirebaseAuth.instance.currentUser;
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(user.uid)
                                .delete()
                                .then((value) {
                              print("Deleted user: " + user.uid);
                            });

                            // var responseData;
                            var res = json.encode({
                              "target_id": user.uid,
                            });
                            await http.delete(
                              Uri.parse(
                                  'https://cupidity-api.herokuapp.com/users/deleteUser/?API_KEY=CUPIDITY'),
                              body: res,
                              headers: {"Content-Type": "application/json"},
                            );
                            if (user.providerData[0].providerId != "phone") {
                              final GoogleSignIn _googleSignIn = GoogleSignIn();
                              GoogleSignInAccount googleSignInAccount =
                                  await _googleSignIn.signIn();
                              GoogleSignInAuthentication
                                  googleSignInAuthentication =
                                  await googleSignInAccount.authentication;
                              AuthCredential credential =
                                  GoogleAuthProvider.credential(
                                      idToken:
                                          googleSignInAuthentication.idToken,
                                      accessToken: googleSignInAuthentication
                                          .accessToken);

                              //use credentials to sign in to Firebase
                              var authResult = await FirebaseAuth.instance
                                  .signInWithCredential(credential);
                              var user = authResult.user;

                              user.delete();
                              await _googleSignIn.signOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewLandingPage(),
                                ),
                                (route) => false,
                              );
                              intializeGlobalVariables();
                            } else {
                              FirebaseAuth auth = FirebaseAuth.instance;
                              try {
                                auth.verifyPhoneNumber(
                                    phoneNumber: user.phoneNumber,
                                    timeout: const Duration(seconds: 60),
                                    verificationCompleted:
                                        (AuthCredential credential) async {
                                      Navigator.of(context).pop();

                                      UserCredential result = await FirebaseAuth
                                          .instance
                                          .signInWithCredential(credential);

                                      User user = result.user;
                                      user.delete();
                                      await auth.signOut();
                                      intializeGlobalVariables();
                                      // print(user.providerData);

                                      //This callback would get called when verification is done automaticlly
                                    },
                                    verificationFailed:
                                        (FirebaseAuthException exception) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: ThemeColor.notBlack,
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            "Please Enter a Valid Phone Number or Sign in with Google",
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                      );
                                    },
                                    codeSent: (String verificationId,
                                        [int forceResendingToken]) {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => Verification(
                                      //       forceResendingToken:
                                      //           forceResendingToken,
                                      //       verificationId: verificationId,
                                      //       auth: auth,
                                      //       phone: user.phoneNumber,
                                      //     ),
                                      //   ),
                                      // );
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Give the code?"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  PinPut(
                                                    fieldsCount: 6,
                                                    //onSubmit: (String pin) => ScaffoldMessenger.of(context).showSnackBar(pin, context),
                                                    focusNode: _pinPutFocusNode,
                                                    controller:
                                                        _pinPutController,
                                                    submittedFieldDecoration:
                                                        _pinPutDecoration
                                                            .copyWith(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                    ),
                                                    selectedFieldDecoration:
                                                        _pinPutDecoration,
                                                    followingFieldDecoration:
                                                        _pinPutDecoration
                                                            .copyWith(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("Confirm"),
                                                  textColor: Colors.white,
                                                  color: Colors.pink,
                                                  onPressed: () async {
                                                    try {
                                                      print(_pinPutController
                                                          .text
                                                          .trim());
                                                      final code =
                                                          _pinPutController.text
                                                              .trim();
                                                      AuthCredential
                                                          credential =
                                                          PhoneAuthProvider
                                                              .credential(
                                                                  verificationId:
                                                                      verificationId,
                                                                  smsCode:
                                                                      code);

                                                      UserCredential result =
                                                          await auth
                                                              .signInWithCredential(
                                                                  credential);

                                                      User user = result.user;

                                                      if (user != null) {
                                                        user.delete();
                                                        await auth.signOut();
                                                        intializeGlobalVariables();
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                NewLandingPage(),
                                                          ),
                                                          (route) => false,
                                                        );
                                                      } else {
                                                        print("Error");
                                                      }
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationID) {
                                      print("Verification ID : " +
                                          verificationID);
                                    });
                              } catch (e) {
                                print("[ERROR] $e");
                              }
                            }
                          }),
                      ActionChip(
                          label: Text('No'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                );
                //
                break;
            }
          },
          enableFeedback: true,
          title: Text(
            title,
            style: GoogleFonts.lato(
              textStyle: GoogleFonts.poppins(
                  color: notBlack, fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          subtitle: Text(
            subTitle,
            style: GoogleFonts.lato(
              textStyle: GoogleFonts.poppins(
                  fontSize: 15,
                  color: notBlack.withOpacity(0.8),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Divider(indent: 16, endIndent: 16),
      ],
    );
  }
}
