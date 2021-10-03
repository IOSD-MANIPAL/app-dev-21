// ignore_for_file: non_constant_identifier_names

//import 'dart:html';

import 'package:file/file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/models/app_user.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';
import 'package:new_registreation1/pages/Constants/gender_list.dart';
import 'package:new_registreation1/pages/registration_process/custom_dropdown.dart';
import 'package:new_registreation1/pages/registration_process/new_registration_process/pages/add_more_pictures.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'dart:html';

class EditProfile extends StatefulWidget {
  final AppUser appUser;

  const EditProfile({Key key, @required this.appUser}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState(appUser);
}

class _EditProfileState extends State<EditProfile> {
  File image;
  final picker=ImagePicker();

  File _cropper;




  int id = 1;
  int id1 = 1;

  SfRangeValues values = const SfRangeValues(18.0, 25.0);

  RangeLabels labels = const RangeLabels('18', "25");
  double minAge = 18;
  double maxAge = 70;

  AppUser appUser;

  var selectedGender;

  var selectedPreferredGender;


  // Future pickImage() async{
  //   final pickedimage= await picker.getImage(source: ImageSource.gallery);
  //   //if(image==null)
  //   //return;
  //   setState(() {
  //     if(pickedimage!=null) {
  //       //_image=File(pickedimage.path)
  //       _image=pickedimage.path as File;
  //
  //     }
  //     else{
  //       print("No image selected");
  //
  //     }
  //   });
  // }
  //
   _EditProfileState(this.appUser);

  Future pickImage() async {
    final pickedOriginalFile = await picker.getImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 0,
    );
    _cropper = pickedOriginalFile != null
        ? await ImageCropper.cropImage(
        sourcePath: pickedOriginalFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16),
        maxHeight: (MediaQuery
            .of(context)
            .size
            .height * 0.8).toInt(),
        maxWidth: (MediaQuery
            .of(context)
            .size
            .width * 0.8).toInt(),
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



  @override
  void initState() {
    super.initState();
    appUser.printDetails();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    List widgets = [
      buildHeadingText('Photos'),
      buildImageCarousel(h, w),
      buildHeadingText('Gender'),
      buildGender(w, h),
      buildHeadingText('Gender Preference'),
      buildPreferredGender(w, h),
      buildHeadingText('Age Preference'),
      ageSlider(h, w),
      buildChooseArtists(w, context),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: buildBackButton(),
          actions: [buildUpdateProfile(w)],
        ),
        body: ListView.builder(
            itemBuilder: (context, index) => widgets[index],
            itemCount: widgets.length));
  }

  ListTile buildChooseArtists(double w, BuildContext context) {
    return ListTile(
      minVerticalPadding: 16,
      leading: const Icon(Icons.music_note_rounded),
      trailing: const Icon(Icons.arrow_forward_rounded),
      contentPadding: EdgeInsets.symmetric(
        horizontal: w * 0.04,
      ),
      title: Text(
        "Update artists",
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        "Change the artists you chose while signing up",
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  buildGender(double w, double h) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: w * 0.02),
      // padding: const EdgeInsets.only(top: 16.0),
      child: CustomDropDown(
        dropdownColor: Colors.white,
        value: appUser.gender,
        itemsList: Genders.GenderList,
        onChanged: (value) {
          setState(() {
            appUser.gender = value;
          });
        },
      ),
    );
  }

  buildPreferredGender(double w, double h) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: w * 0.02),
      // padding: const EdgeInsets.only(top: 16.0),
      child: CustomDropDown(
        dropdownColor: Colors.white,
        value: appUser.genderPref,
        itemsList: Genders.GenderList,
        onChanged: (value) {
          setState(() {
            appUser.genderPref = value;
          });
        },
      ),
    );
  }

  buildImageCarousel(double h, double w) {
    return Container(
      height: h * 0.4,
      margin: EdgeInsets.only(left: w * 0.04),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...appUser.images.map(
            (e) => Container(
              constraints: const BoxConstraints(maxWidth: 150, maxHeight: 350),
              margin: EdgeInsets.fromLTRB(0, w * 0.04, w * 0.04, w * 0.04),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Image.network(
                        e,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  blackGradient(),
                  TextButton(
                    style: TextButton.styleFrom(
                      fixedSize: Size(w * 0.33, w * 0.15),
                    ),
                    child: SvgPicture.asset(
                      "assets/changeButton.svg",
                      fit: BoxFit.contain,
                    ),
                    onPressed: () {
                      setState(() {
                        //appUser.images.remove(e);
                        appUser.images.remove(e);
                        pickImage();
                        appUser.images.add(_image);
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 150, maxHeight: 350),
            margin: EdgeInsets.fromLTRB(0, w * 0.04, w * 0.04, w * 0.04),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.pink[100],
                    child: const AspectRatio(
                      aspectRatio: 9 / 16,
                      child:
                          Icon(FontAwesomeIcons.plusCircle, color: Colors.pink),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ageSlider(double h, double w) {
    return Container(
      margin:
          EdgeInsets.only(top: h * 0.04, left: 12, right: 12, bottom: h * 0.02),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          const BoxShadow(
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
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
            child: Column(
              children: [
                SfRangeSlider(
                  activeColor: ThemeColor.maroon,
                  //TODO: change 18.0 and 70.0 to user's previous selections
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
                  // showDivisors: true,
                  stepSize: 1,
                  interval: 10,
                  enableIntervalSelection: true,
                  values: values,
                  labelPlacement: LabelPlacement.onTicks,
                  onChanged: (SfRangeValues val) {
                    setState(() {
                      values = val;
                      maxAge = val.end;
                      minAge = val.start;

                      labels = RangeLabels(values.start.toInt().toString(),
                          values.end.toInt().toString());
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget blackGradient() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black38,
              Colors.black54,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 0.9],
          ),
        ),
      ),
    );
  }

  Widget buildHeadingText(String heading) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        heading,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget buildBackButton() {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget buildUpdateProfile(double w) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.04),
        child: const Text(
          "Update Profile",
          style: TextStyle(fontSize: 16, color: ThemeColor.maroon),
        ),
      ),
    );
  }
}



  // Widget buildRadio() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: <Widget>[
  //       Row(
  //         children: [
  //           Radio(
  //             activeColor: maroon,
  //             value: 1,
  //             groupValue: id,
  //             onChanged: (val) {
  //               setState(() {
  //                 radioButtonItem = 'ONE';
  //                 id = 1;
  //               });
  //             },
  //           ),
  //           Text(
  //             'Male',
  //             style: new GoogleFonts.poppins(fontSize: 17.0),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: [
  //           Radio(
  //             activeColor: maroon,
  //             value: 2,
  //             groupValue: id,
  //             onChanged: (val) {
  //               setState(() {
  //                 radioButtonItem = 'TWO';
  //                 id = 2;
  //               });
  //             },
  //           ),
  //           Text(
  //             'Female',
  //             style: new GoogleFonts.poppins(
  //               fontSize: 17.0,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: [
  //           Radio(
  //             activeColor: maroon,
  //             value: 3,
  //             groupValue: id,
  //             onChanged: (val) {
  //               setState(() {
  //                 radioButtonItem = 'THREE';
  //                 id = 3;
  //               });
  //             },
  //           ),
  //           Text(
  //             'Others',
  //             style: new GoogleFonts.poppins(fontSize: 17.0),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget buildRadio1() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: <Widget>[
  //       Row(
  //         children: [
  //           Radio(
  //             activeColor: maroon,
  //             value: 1,
  //             groupValue: id1,
  //             onChanged: (val) {
  //               setState(() {
  //                 radioButtonItem = 'ONE';
  //                 id1 = 1;
  //               });
  //             },
  //           ),
  //           Text(
  //             'Male',
  //             style: new GoogleFonts.poppins(fontSize: 17.0),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: [
  //           Radio(
  //             activeColor: maroon,
  //             value: 2,
  //             groupValue: id1,
  //             onChanged: (val) {
  //               setState(() {
  //                 radioButtonItem = 'TWO';
  //                 id1 = 2;
  //               });
  //             },
  //           ),
  //           Text(
  //             'Female',
  //             style: new GoogleFonts.poppins(
  //               fontSize: 17.0,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: [
  //           Radio(
  //             activeColor: maroon,
  //             value: 3,
  //             groupValue: id1,
  //             onChanged: (val) {
  //               setState(() {
  //                 radioButtonItem = 'THREE';
  //                 id1 = 3;
  //               });
  //             },
  //           ),
  //           Text(
  //             'Others',
  //             style: new GoogleFonts.poppins(fontSize: 17.0),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Container ageSlider(double h, double w, SfRangeValues _values) {
  //   return Container(
  //     margin:
  //         EdgeInsets.only(top: h * 0.04, left: 12, right: 12, bottom: h * 0.02),
  //     child: SfRangeSlider(

  //       activeColor: maroon,
  //       min: minAge,
  //       max: maxAge,
  //       showTicks: true,
  //       showLabels: true,
  //       enableTooltip: true,
  //       interval: 10,
  //       enableIntervalSelection: true,
  //       values: _values,
  //       onChanged: (SfRangeValues values) {
  //         setState(() {
  //           this._values = values;
  //         });
  //       },
  //     ),
  //   );
  // }


  //the age entering row

  // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * 0.3,
                //       child: TextFormField(
                //         controller: _mincontroller,
                //         // initialValue: values.end.toString(),
                //         keyboardType: TextInputType.number,
                //         decoration: InputDecoration(
                //           labelText: "Minimum Age",
                //           hintText: "$minAge",
                //         ),
                //         style: GoogleFonts.lato(),
                //         onChanged: (value) {
                //           setState(() {
                //             minAge = double.parse(value);
                //           });
                //         },
                //         onEditingComplete: () {
                //           setState(
                //             () {
                //               if (minAge > 70 ||
                //                   minAge < 18 ||
                //                   minAge > maxAge) {
                //                 _mincontroller.text = "";
                //                 minAge = 18;
                //                 ScaffoldMessenger.of(context).showSnackBar(
                //                   SnackBar(
                //                     backgroundColor: ThemeColor.notBlack,
                //                     elevation: 5,
                //                     shape: RoundedRectangleBorder(
                //                         borderRadius:
                //                             BorderRadius.circular(16)),
                //                     behavior: SnackBarBehavior.floating,
                //                     content:
                //                         const Text("Minimum Age should be 18"),
                //                   ),
                //                 );
                //               }
                //             },
                //           );
                //         },
                //       ),
                //     ),
                //     TextFormField(
                //       controller: _maxcontroller,
                //       keyboardType: TextInputType.number,
                //       decoration: InputDecoration(
                //         // labelText: "Maximum Age",
                //         labelText: "$maxAge",
                //       ),
                //       style: GoogleFonts.lato(),
                //       onChanged: (value) {
                //         setState(() {
                //           maxAge = double.parse(value);
                //           if (maxAge > 70 || maxAge < 18) {
                //             _mincontroller.text = "";
                //           }
                //         });
                //       },
                //       onEditingComplete: () {
                //         setState(() {
                //           if (maxAge > 70 || maxAge < 18 || minAge > maxAge) {
                //             _maxcontroller.text = "";
                //             maxAge = 70;
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(
                //                 backgroundColor: ThemeColor.notBlack,
                //                 elevation: 5,
                //                 shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(16)),
                //                 behavior: SnackBarBehavior.floating,
                //                 content:
                //                     const Text("Maximum Age should be 18"),
                //               ),
                //             );
                //             //   labels = RangeLabels(
                //             //       minAge.toString(), maxAge.toString());
                //             //   values = RangeValues(
                //             //       minAge.toDouble(), maxAge.toDouble());
                //             // } else {
                //             //   labels = RangeLabels(
                //             //       minAge.toString(), maxAge.toString());
                //             //   values = RangeValues(
                //             //       minAge.toDouble(), maxAge.toDouble());
                //             //   _maxcontroller.text = "";
                //           }
                //         });
                //       },
                //     ),
                //   ],
                // )
