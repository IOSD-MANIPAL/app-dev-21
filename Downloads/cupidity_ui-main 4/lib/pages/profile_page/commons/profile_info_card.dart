import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_registreation1/pages/profile_page/commons/two_line_item.dart';
import 'package:new_registreation1/pages/profile_page/style_guide/colors.dart';

class ProfileInfoCard extends StatelessWidget {
  final firstText, secondText, hasImage, icon;

  const ProfileInfoCard(
      {Key key,
      this.firstText,
      this.secondText,
      this.hasImage = false,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: width / 4,
        child: Card(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: hasImage
              ? Center(
                  // child: Image.asset(
                  //   icon,
                  //   color: pinkColor,
                  //   width: 25,
                  //   height: 25,
                  // ),
                  child: Icon(
                    icon,
                    color: pinkColor,
                  ),
                )
              : TwoLineItem(
                  firstText: firstText,
                  secondText: secondText,
                ),
        ),
      ),
    );
  }
}
