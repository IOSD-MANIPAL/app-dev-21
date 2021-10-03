/*
This page collects the users photo. and saves the data.
 */

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';
import 'package:new_registreation1/pages/registration_process/new_registration_process/pages/add_more_pictures.dart';
// import 'package:new_registreation1/pages/registration_process/new_registration_process/add_more_pictures.dart';
import 'package:new_registreation1/pages/registration_process/new_registration_process/pages/components/custom_route.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../global_variables.dart';

class ProfilePictureSelection extends StatefulWidget {
  const ProfilePictureSelection({Key key}) : super(key: key);

  @override
  _ProfilePictureSelectionState createState() =>
      _ProfilePictureSelectionState();
}

class _ProfilePictureSelectionState extends State<ProfilePictureSelection>
    with SingleTickerProviderStateMixin {
  final picker = ImagePicker();
  File _cropper;

  Future getImage() async {
    final pickedOriginalFile = await picker.getImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 0,
    );
    _cropper = pickedOriginalFile != null
        ? await ImageCropper.cropImage(
            sourcePath: pickedOriginalFile.path,
            aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16),
            maxHeight: (MediaQuery.of(context).size.height * 0.8).toInt(),
            maxWidth: (MediaQuery.of(context).size.width * 0.8).toInt(),
            compressQuality: 50,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: const AndroidUiSettings(
                toolbarColor: ThemeColor.maroon,
                toolbarTitle: "Cupidity Cropper",
                toolbarWidgetColor: Colors.white,
                backgroundColor: Colors.white,
                statusBarColor: ThemeColor.maroon))
        : null;
    // 14 * x = 250 / 1024 => x = (250/1024) * 1/14
    double length = pickedOriginalFile != null
        ? await File(pickedOriginalFile.path).length() / 1024 / 1024
        : 0.1;
    print("SIZE LENGTH: $length");
    print("Quality: ${(250 / length * 100).toInt()}");
    File pickedFile = await FlutterNativeImage.compressImage(
      _cropper.path,
      quality: length > (250 / 1024) ? 24 : 100,
    );

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        // print('No image selected.');
      }
    });
  }

  AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
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
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: ThemeColor.notBlack,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: image == null ? chooseImageUi(h, w) : imagePreviewUi(w, h),
    );
  }

  Column imagePreviewUi(double w, double h) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: FadeTransition(
                opacity: _animationController,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      SelectedPicture(w: w, h: h),
                      BlackGradient(w: w, h: h),
                      chooseAnotherPictureButton(w),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        buildNextButton(h, w),
      ],
    );
  }

  Widget chooseImageUi(double h, double w) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(_animationController),
      child: ListView(
        children: [
          buildProfilePictureText(h, w),
          buildSvgImage(h, w),
          buildQuickDetailsText(h, w),
          buildInfoText(h, w),
          buildAddPicture(h, w),
        ],
      ),
    );
  }

  Positioned chooseAnotherPictureButton(double w) {
    return Positioned(
      bottom: w * 0.025,
      left: w * 0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Looks Great!',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: ThemeColor.white,
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: w * 0.025),
                backgroundColor: ThemeColor.maroon,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24))),
            onPressed: () {
              setState(() {
                uploadingProfilePictureAttempt = 0;
              });
              getImage();
            },
            child: Center(
              child: Text(
                "Picked by mistake? Choose another one",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ThemeColor.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future uploadProfile() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: SingleChildScrollView(
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
    var profileAddress;
    final User user = auth.currentUser;
    Reference reference =
        FirebaseStorage.instance.ref().child('${user.uid}/profile');
    UploadTask uploadTask = reference.putFile(image);
    // ignore: unused_local_variable
    TaskSnapshot snapshot = await uploadTask;
    // print(snapshot.metadata);
    profileAddress = await reference.getDownloadURL();
    downloadAddress.add(profileAddress);
    currentAppUser.profile = profileAddress;
    currentAppUser.printDetails();
  }

  Widget buildNextButton(double h, double w) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: CircularPercentIndicator(
        radius: 85,
        circularStrokeCap: CircularStrokeCap.round,
        lineWidth: 4.0,
        // restartAnimation: true,
        animateFromLastPercent: true,
        animation: true,
        animationDuration: 500,
        percent: (6 / 7),
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
                uploadingProfilePictureAttempt++;
                if (uploadingProfilePictureAttempt == 1) {
                  uploadProfile().then((value) {
                    currentAppUser.printDetails();
                    Navigator.pop(context);
                    Navigator.push(context,
                        CustomMaterialPageRoute(builder: (context) {
                      return const AddMoreImages();
                    }));
                  });
                } else {
                  Navigator.push(context,
                      CustomMaterialPageRoute(builder: (context) {
                    return const AddMoreImages();
                  }));
                }
              }),
        ),
        backgroundColor: Colors.grey[400],
        progressColor: Colors.pink,
      ),
    );
  }

  Widget buildAddPicture(double h, double w) {
    return Center(
        child: CircleAvatar(
            backgroundColor: ThemeColor.maroon,
            radius: w * 0.15,
            child: InkWell(
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(32),
                splashColor: ThemeColor.maroon,
                onTap: () {
                  getImage();
                },
                child: CircleAvatar(
                  radius: w * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_a_photo_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Add a photo",
                          style: GoogleFonts.lato(
                            textStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              color: ThemeColor.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  backgroundColor: const Color(0xFFFF6366),
                ))));
  }

  Widget buildProfilePictureText(double h, double w) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Profile Picture",
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

  Widget buildQuickDetailsText(double h, double w) {
    return Container(
        margin: EdgeInsets.only(
          left: w * 0.1,
          right: w * 0.1,
          top: h * 0.01,
          bottom: h * 0.01,
        ),
        child: Text(
          'Choose a picture in which your face is clearly visible',
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ThemeColor.notBlack,
            ),
          ),
        ));
  }

  Widget buildInfoText(double h, double w) {
    return Container(
        margin: EdgeInsets.only(
          left: w * 0.1,
          right: w * 0.1,
          bottom: h * 0.05,
        ),
        child: Text(
          '(This will also be shown during matching)',
          style: GoogleFonts.lato(
            textStyle: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: ThemeColor.notBlack.withOpacity(0.8),
            ),
          ),
          //  textAlign: TextAlign.center,
        ));
  }

  Widget buildSvgImage(double h, double w) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.04),
        height: h / 3,
        child: SvgPicture.asset('assets/image9.svg'));
  }
}

class SelectedPicture extends StatelessWidget {
  const SelectedPicture({
    Key key,
    @required this.w,
    @required this.h,
  }) : super(key: key);

  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        image,
        fit: BoxFit.fill,
        height: h * 0.75,
      ),
    );
  }
}

class BlackGradient extends StatelessWidget {
  const BlackGradient({
    Key key,
    @required this.w,
    @required this.h,
  }) : super(key: key);

  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: (h / w == 16 / 9) ? h * 0.25 : h * 0.2,
        width: w - w * 0.04,
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.,
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black54,
              Colors.black87,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3, 2.0],
          ),
        ),
      ),
    );
  }
}
