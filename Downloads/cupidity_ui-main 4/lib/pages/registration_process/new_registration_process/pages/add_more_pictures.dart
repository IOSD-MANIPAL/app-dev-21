import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_registreation1/global_variables.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';
import 'package:new_registreation1/pages/match_page/match_page.dart';
import 'package:new_registreation1/pages/registration_process/new_registration_process/pages/components/custom_route.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:showcaseview/showcaseview.dart';

class AddMoreImages extends StatefulWidget {
  const AddMoreImages({Key key}) : super(key: key);

  @override
  _AddMoreImagesState createState() => _AddMoreImagesState();
}

class _AddMoreImagesState extends State<AddMoreImages> {
  String selectedValue;
  FirebaseAuth auth = FirebaseAuth.instance;

  final picker = ImagePicker();

  File _cropper;
  File _selectedFile;

  File finalImg;
  getImage(ImageSource source, index, BuildContext context) async {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var pickedOriginalFile =
        await picker.getImage(source: source, imageQuality: 0);
    _cropper = pickedOriginalFile != null
        ? await ImageCropper.cropImage(
            sourcePath: pickedOriginalFile.path,
            aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16),
            maxHeight: (height * 0.8).toInt(),
            maxWidth: (width * 0.8).toInt(),
            compressQuality: 100,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.pink,
              toolbarTitle: "Cupidity Cropper",
              statusBarColor: Colors.pink.shade900,
              backgroundColor: Colors.white,
            ))
        : null;
    double length = await File(_cropper.path).length() / 1024 / 1024;
    print("SIZE LENGTH: $length");
    print("Compression Factor: ${((250 / 1024) / length * 100).toInt()}");
    finalImg = await FlutterNativeImage.compressImage(
      _cropper.path,
      quality:
          length > (250 / 1024) ? ((250 / 1024) / length * 100).toInt() : 100,
    );
    setState(() {
      if (finalImg != null) {
        _selectedFile = File(finalImg.path);
        selectedImgFiles[index] = _selectedFile;
        print(selectedImgFiles.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                buildTitle(h, w),
                buildIllustration(h, w),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildAddPictureButton(h, w, 0),
                      buildAddPictureButton(h, w, 1),
                      buildAddPictureButton(h, w, 2),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildAddPictureButton(h, w, 3),
                      buildAddPictureButton(h, w, 4),
                      buildAddPictureButton(h, w, 5),
                    ],
                  ),
                ),
                // ...selectedImgFiles.map((e) => buildAddPictureButton(h, w, e))
                buildNextButton(h, w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future uploadImage() async {
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
    final User user = auth.currentUser;
    // int i = 0;
    for (int i = 0; i < selectedImgFiles.length; i++) {
      if (selectedImgFiles[i] == null) continue;
      Reference reference =
          FirebaseStorage.instance.ref().child('${user.uid}/$i');
      UploadTask uploadTask = reference.putFile(selectedImgFiles[i]);
      // ignore: unused_local_variable
      TaskSnapshot snapshot = await uploadTask;
      // print(snapshot.metadata);
      downloadAddress.add(await reference.getDownloadURL());
    }
    print(downloadAddress);
    setState(() {
      currentAppUser.images = downloadAddress;
      currentAppUser.printDetails();
    });
    await FirebaseFirestore.instance
        .collection('/users')
        .doc(user.uid)
        .set({'imageUrl': downloadAddress}, SetOptions(merge: true))
        .then((value) => print('Profile Set'))
        .catchError((e) => print(e));
  }

  Future uploadToFirebase() async {
    User user = auth.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc('${user.uid}')
        .update({
      'name': currentAppUser.name,
      'age': currentAppUser.age,
      'age_pref_min': currentAppUser.ageMinPref,
      'age_pref_max': currentAppUser.ageMaxPref,
      'gender': currentAppUser.gender,
      'genderPref': currentAppUser.genderPref,
      'bio': currentAppUser.bio,
      'dob': currentAppUser.dob,
      'chat_index': [],
      'user_regdone': true
    }).then((value) {
      print("Data set");
    }).catchError((error) {
      print(error);
    });
    setState(() {
      selectedImgFiles = List.filled(6, null);
      sendUser();
      currentAppUser.images = null;
    });
  }

  sendUser() async {
    // {
    //     "_id" : String,
    //     "name" : String,
    //     "age" :  Integer,
    //     "age_pref" : {
    //         "max" : Integer,
    //         "min" : Integer
    //     },
    //     "images": [String],
    //     "job_title": String,
    //     "API_KEY": String,
    // }
    print("SENDING USER");
    var encodedArtists = selectedArtists.map((e) => e.toJson()).toList();
    print(encodedArtists);
    var res = json.encode({
      "_id": currentAppUser.uid,
      "name": currentAppUser.name,
      // "age": int.parse(currentAppUser.age),
      "dob": currentAppUser.dob,
      "age": currentAppUser.age,
      "age_pref": {
        "age_max": currentAppUser.ageMaxPref,
        "age_min": currentAppUser.ageMinPref
      },
      "gender": currentAppUser.gender,
      "gender_pref": currentAppUser.genderPref,
      "images": currentAppUser.images,
      "bio": currentAppUser.bio,
      "fav_artists": encodedArtists,
    });
    print(res);
    try {
      final response = await http.post(
        Uri.parse(
            "https://cupidity-api.herokuapp.com/users/addUser/?API_KEY=CUPIDITY"),
        body: res,
        headers: {"Content-Type": "application/json"},
      );
      var responseData = json.decode(response.body);
      print("ID: ${responseData["_id"]}");
    } catch (e) {
      print(e);
    }
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
        percent: 0.999,
        center: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
              color: ThemeColor.maroon, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              uploadImage().then((value) {
                uploadToFirebase().then((value) {
                  // currentAppUser.printDetails();
                  setState(() {});
                  Navigator.pushAndRemoveUntil(
                    context,
                    CustomMaterialPageRoute(builder: (context) {
                      return ShowCaseWidget(
                                builder: Builder(
                                  builder: (context) => const MatchPage2(newUser:true),
                                ),
                              );
                           
                    }),
                    (route) => false,
                  );
                });
              });
            },
          ),
        ),
        backgroundColor: Colors.grey[400],
        progressColor: Colors.pink,
      ),
    );
  }

  Widget buildTitle(double h, double w) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.1),
      child: Text(
        "Adding more Pictures work like a charm ❤",
        style: GoogleFonts.lato(
            textStyle: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }

  Widget buildIllustration(double h, double w) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.01),
      height: h / 4.33,
      child: SvgPicture.asset('assets/image13.svg'),
    );
  }

  Widget buildAddPictureButton(double h, double w, index) {
    if (selectedImgFiles.elementAt(index) == null) {
      return Padding(
        padding:
            EdgeInsets.fromLTRB(h * 0.005, h * 0.005, h * 0.005, h * 0.005),
        child: InkWell(
          onTap: () {
            getImage(ImageSource.gallery, index, context);
          },
          splashColor: ThemeColor.maroon,
          borderRadius: BorderRadius.circular(16),
          child: Center(
              child: Container(
            height: h * 0.15 * 1.25,
            width: (9 / 16) * (h * 0.15) * 1.25,
            decoration: BoxDecoration(
                color: const Color(0xffFF6366),
                borderRadius: BorderRadius.circular(16)),
            child: const Icon(
              Icons.add_a_photo_outlined,
              color: Colors.white,
            ),
          )),
        ),
      );
    } else {
      return Padding(
        padding:
            EdgeInsets.fromLTRB(h * 0.005, h * 0.005, h * 0.005, h * 0.005),
        child: InkWell(
          onTap: () {
            getImage(ImageSource.gallery, index, context);
          },
          onLongPress: () {
            setState(() {
              selectedImgFiles[index] = null;
            });
          },
          splashColor: ThemeColor.maroon,
          borderRadius: BorderRadius.circular(16),
          child: Center(
              child: Container(
            height: h * 0.15 * 1.25,
            width: (9 / 16) * (h * 0.15) * 1.25,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(selectedImgFiles.elementAt(index)),
                  fit: BoxFit.fill,
                ),
                color: const Color(0xffFF6366),
                border: Border.all(color: const Color(0xffFF6366), width: 2.0),
                borderRadius: BorderRadius.circular(16)),
          )),
        ),
      );
    }
  }
}
