/*
This page collects the registration data for the age preference and gender preferences.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/gender_list.dart';
import 'bio.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../global_variables.dart';
import '../../custom_dropdown2.dart';
import 'components/custom_route.dart';

class UserPreferences extends StatefulWidget {
  const UserPreferences({Key key, @required this.name}) : super(key: key);
  final String name;
  @override
  _UserPreferencesState createState() => _UserPreferencesState();
}

class _UserPreferencesState extends State<UserPreferences>
    with SingleTickerProviderStateMixin {
  SfRangeValues values = const SfRangeValues(18.0, 25.0);
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

    return Scaffold(
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
                    buildSvgImage(h),
                    buildPreferencesText(),
                    ageSlider(
                      h,
                      w,
                    ),
                    CustomDropDown2(
                      value: selectedGenderPreference,
                      itemsList: Genders.GenderList,
                      onChanged: (value) {
                        setState(() {
                          selectedGenderPreference = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildNextButton(h, w),
        ],
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
        restartAnimation: true,
        animateFromLastPercent: true,
        animation: true,
        animationDuration: 500,
        percent: (2 / 7),
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
              if (selectedGenderPreference != null) {
                currentAppUser.ageMinPref = minAge;
                currentAppUser.ageMaxPref = maxAge;
                currentAppUser.genderPref = selectedGenderPreference;
                currentAppUser.printDetails();
                Navigator.push(
                  context,
                  CustomMaterialPageRoute(
                    builder: (context) {
                      return const Bio();
                    },
                  ),
                );
              } else {
                showSnackBar("Choose your gender preference");
              }
            },
          ),
        ),
        backgroundColor: Colors.grey[400],
        progressColor: Colors.pink,
      ),
    );
  }

  Widget buildSvgImage(double h) {
    return SizedBox(
        height: h / 3.5, child: SvgPicture.asset('assets/image11.svg'));
  }

  Widget buildVerificationText() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Hi",
              style: GoogleFonts.lato(
                  textStyle: GoogleFonts.poppins(
                      fontSize: 32,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "${widget.name}" " ,",
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

  Widget buildPreferencesText() {
    return Center(
      child: Text(
        "What are your preferences?",
        style: GoogleFonts.lato(
            textStyle: GoogleFonts.poppins(
          fontSize: 18,
          letterSpacing: 0.0,
          color: Colors.black,
        )),
      ),
    );
  }

  Container ageSlider(
    double h,
    double w,
  ) {
    return Container(
      margin:
          EdgeInsets.only(top: h * 0.04, left: 12, right: 12, bottom: h * 0.02),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffBDBFC0),
            spreadRadius: 0,
            blurRadius: 4.68,
            offset: Offset(0, 2.34),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Your Age Preference",
                style: GoogleFonts.lato(
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    color: ThemeColor.notBlack.withOpacity(.8),
                  ),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
            child: SfRangeSlider(
                activeColor: Colors.red[700],
                inactiveColor: Colors.red[300],
                min: 18.0,
                max: 70.0,
                startThumbIcon: CircleAvatar(
                  backgroundColor: ThemeColor.maroon,
                  child: Text(
                    values.start.toInt().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                endThumbIcon: CircleAvatar(
                  backgroundColor: ThemeColor.maroon,
                  child: Text(
                    values.end.toInt().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                stepSize: 1,
                interval: 10,
                enableIntervalSelection: true,
                values: values,
                onChanged: (SfRangeValues val) {
                  setState(() {
                    values = val;
                    maxAge = val.end.toInt();
                    minAge = val.start.toInt();
                  });
                }),
          ),
        ],
      ),
    );
  }

  showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}

// Widget returnGender(
  //   int index,
  //   value,
  // ) {
  //   return ListTile(
  //     isThreeLine: false,
  //     tileColor: selectedIndex == index ? ThemeColor.maroon : null,
  //     onTap: () {
  //       // print('selected = $selectedIndex');
  //       setState(() {
  //         selectedIndex = index;
  //         selectedGenderPreference = Genders.GenderList[index];
  //       });
  //       Navigator.pop(context);
  //     },
  //     title: Text(Genders.GenderList[index],
  //         style: GoogleFonts.raleway(
  //           textStyle: GoogleFonts.poppins(
  //             fontSize: 18,
  //             color: selectedIndex == index
  //                 ? Colors.white
  //                 : const Color(0xff2F2E41),
  //           ),
  //         )),
  //   );
  // }

  // Future genderBottomSheet(BuildContext context, double w, double h, value) {
  //   return showModalBottomSheet(
  //       context: context,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       builder: (BuildContext context) {
  //         return Container(
  //           padding: EdgeInsets.symmetric(horizontal: w * 0.02),
  //           height: h * 0.6,
  //           child: Flex(
  //             direction: Axis.vertical,
  //             children: [
  //               Container(
  //                 margin: EdgeInsets.symmetric(vertical: w * 0.04),
  //                 child: Text(
  //                   "Select Your Preferred Gender",
  //                   style: GoogleFonts.raleway(
  //                     textStyle: GoogleFonts.poppins(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.w600,
  //                       color: const Color(0xff2F2E41),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: h * 0.49,
  //                 child: ListView.separated(
  //                     itemBuilder: (context, int index) {
  //                       return returnGender(index, value);
  //                     },
  //                     separatorBuilder: (context, int index) {
  //                       return const Divider();
  //                     },
  //                     itemCount: 56),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }