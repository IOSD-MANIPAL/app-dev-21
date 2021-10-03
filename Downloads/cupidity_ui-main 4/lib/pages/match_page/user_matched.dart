import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserMatched {
  
  final Color notBlack = Color(0xff2F2E41);
  final Color pinkish = Color(0xffFE3782);
  final Color maroon = Color(0xffDA2753);
  final Color shadow = Color(0xffBDBFC0);


  _userMatchedPopup(context) {
    final TextStyle bold = TextStyle(
      color: maroon,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );
    final TextStyle small = TextStyle(
      color: pinkish,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
      context: context,
      builder: (context) => Container(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          height: MediaQuery.of(context).size.height * 0.33,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: SvgPicture.asset("assets/images/true_love.svg",
                    width: MediaQuery.of(context).size.width * 0.5),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: bold,
                      text: "You've struck a chord with ",
                      children: [
                        TextSpan(
                          text: "Ankita",
                          style: bold,
                        ),
                        TextSpan(
                          text: " ! 💖",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Compose a beautiful melody together!",
                      style: small,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 2.5,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        primary: maroon,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Start Chatting",
                        style: bold.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),),
    );
  }
}
