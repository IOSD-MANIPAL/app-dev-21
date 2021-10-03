/*
This page collects the registration data for the name,date of birth and gender.
 */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../global_variables.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/gender_list.dart';
import 'age_gender_preference.dart';
import 'landing_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../custom_dropdown.dart';
import 'components/custom_route.dart';

class NameAgeGender extends StatefulWidget {
  const NameAgeGender({Key key}) : super(key: key);

  @override
  _NameAgeGenderState createState() => _NameAgeGenderState();
}

class _NameAgeGenderState extends State<NameAgeGender>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final TextEditingController _nameController = TextEditingController();
  String selectedGender;
  DateTime datePicked = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  bool dob = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
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

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light));
    return WillPopScope(
      onWillPop: () {
        showDialog(
          context: context,
          builder: (context) {
            return alertDialogue(context);
          },
        );
        return Future(() => false);
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar(context),
          body: FadeTransition(
            opacity: _animationController,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildVerificationText(),
                        buildSvgImage(h),
                        buildQuickDetailsText(w),
                        buildName(h, w),
                        buildAge(h, w),
                        buildGender(w, h),
                      ],
                    ),
                  ),
                ),
                _isKeyBoardOpen ? const SizedBox() : buildNextButton(h, w),
              ],
            ),
          ),
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

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: BackButton(
        color: ThemeColor.notBlack,
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              _createRoute(const NewLandingPage()), (route) => false);
        },
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
              "Welcome To",
              style: GoogleFonts.lato(
                  textStyle: GoogleFonts.poppins(
                      fontSize: 32, color: ThemeColor.notBlack)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Cupidity",
              style: GoogleFonts.lato(
                textStyle: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.notBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSvgImage(double h) {
    return SizedBox(
        height: h / 3.5, child: SvgPicture.asset('assets/image3.svg'));
  }

  Widget buildQuickDetailsText(double w) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.2),
        child: Text(
          "We Just Need A Few Quick Details To Continue",
          style: GoogleFonts.lato(
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              color: ThemeColor.notBlack,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildName(double h, double w) {
    return Container(
      margin: EdgeInsets.all(w * 0.04),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        borderOnForeground: false,
        type: MaterialType.card,
        elevation: 3,
        shadowColor: ThemeColor.shadow,
        child: Form(
          key: _formKey,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: ThemeColor.maroon,
            cursorRadius: const Radius.circular(16),
            expands: false,
            validator: (value) {
              if (value.length < 3) {
                return 'Please a valid name';
              } else if (value.contains(RegExp("[0-9]"))) {
                return 'name cannot contain any numbers';
              } else {
                return null;
              }
            },
            controller: _nameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter Your Name',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAge(double h, double w) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.04),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          borderOnForeground: false,
          type: MaterialType.card,
          elevation: 3,
          shadowColor: ThemeColor.shadow,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fixedSize: Size(w * 0.9, h / 16),
                primary: Colors.white,
                shadowColor: ThemeColor.shadow,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: dob
                    ? Text(
                        DateFormat("dd-MM-yyyy").format(datePicked),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ThemeColor.notBlack.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.left,
                      )
                    : Text(
                        "Enter your Date Of Birth",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ThemeColor.notBlack.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.left,
                      ),
              ),
              onPressed: () async {
                try {
                  datePicked = await DatePicker.showSimpleDatePicker(
                    context,
                    textColor: ThemeColor.notBlack,
                    reverse: true,
                    initialDate: DateTime(DateTime.now().year - 18,
                        DateTime.now().month, DateTime.now().day),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(DateTime.now().year - 18,
                        DateTime.now().month, DateTime.now().day),
                    dateFormat: "dd-MMMM-yyyy",
                    locale: DateTimePickerLocale.en_us,
                    looping: false,
                    titleText: "Date of Birth",
                    pickerMode: DateTimePickerMode.date,
                  );

                  setState(() {
                    datePicked ??= DateTime.now();
                    // print(datePicked.year);
                    dob = true;
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
        ));
  }

  Widget buildGender(double w, double h) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: w * 0.02),
      // padding: const EdgeInsets.only(top: 16.0),
      child: CustomDropDown(
        value: selectedGender,
        itemsList: Genders.GenderList,
        dropdownColor: Colors.white,
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
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
        percent: (1 / 7),
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
              if (validated()) {
                FirebaseAuth _auth = FirebaseAuth.instance;
                User user = _auth.currentUser;
                currentAppUser.name = _nameController.text;
                currentAppUser.dob =
                    DateFormat("yyyy-MM-dd").format(datePicked);
                currentAppUser.uid = user.uid;
                currentAppUser.age =
                    DateTime.now().difference(datePicked).inDays ~/ 365;
                currentAppUser.gender = selectedGender;
                currentAppUser.printDetails();
                goToNextPage();
              } else {
                showErrorMessage();
              }
            },
          ),
        ),
        backgroundColor: Colors.grey[400],
        progressColor: Colors.pink,
      ),
    );
  }

  bool validated() {
    if (_formKey.currentState.validate() && selectedGender != null && dob) {
      return true;
    } else {
      return false;
    }
  }

  void showErrorMessage() {
    !_formKey.currentState.validate() && selectedGender == null && !dob
        ? showSnackBar("Enter all the details")
        : _formKey.currentState.validate() && selectedGender == null && dob
            ? showSnackBar("Choose your gender")
            : _formKey.currentState.validate() && selectedGender != null && !dob
                ? showSnackBar("Choose your age")
                : showSnackBar("Enter a valid name!");
  }

  void goToNextPage() {
    Navigator.push(
      context,
      CustomMaterialPageRoute(
        builder: (context) {
          return UserPreferences(name: _nameController.text);
        },
      ),
    );
  }

  AlertDialog alertDialogue(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure you want to exit registration process?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  _createRoute(const NewLandingPage()), (route) => false);
            },
            child: const Text("Yes")),
        TextButton(
            style: TextButton.styleFrom(backgroundColor: ThemeColor.maroon),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "No,take me back",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }

  void showSnackBar(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
      ));
}
