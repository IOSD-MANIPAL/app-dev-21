import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'assets.dart';
import 'network_image.dart';

class AboutMeInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color color1 = Colors.pink[100];
    final Color color2 = Color(0xFFF48FB1);
    final String image = avatars[0];
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [color1, color2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                // Text(
                //   "About me",
                //   style: GoogleFonts.poppins(
                //       color: Colors.white,
                //       fontSize: 28,
                //       fontStyle: FontStyle.italic),
                // ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: PNetworkImage(
                              image,
                              fit: BoxFit.cover,
                            )),
                      ),
                      // Container(
                      //   alignment: Alignment.topCenter,
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 10.0, vertical: 5.0),
                      //     decoration: BoxDecoration(
                      //         color: Colors.yellow,
                      //         borderRadius: BorderRadius.circular(20.0)),
                      //     child: Text("3.7mi away"),
                      //   ),
                      // )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Music I like",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Icon(
                    //   Icons.location_on,
                    //   size: 16.0,
                    //   color: Colors.grey,
                    // ),
                    // Text(
                    //   "San Diego, California, USA",
                    //   style: GoogleFonts.poppins(color: Colors.grey.shade600),
                    // )
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // MusicTags(),
                  ],
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 16.0),
                        margin: const EdgeInsets.only(
                            top: 30, left: 20.0, right: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color1, color2],
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              color: Colors.white,
                              icon: Icon(FontAwesomeIcons.user),
                              onPressed: () {},
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.location_on),
                              onPressed: () {},
                            ),
                            Spacer(),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.message),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.favorite,
                            color: Colors.pink,
                          ),
                          backgroundColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "About me",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            actions: <Widget>[
              // IconButton(
              //   icon: Icon(Icons.notifications),
              //   onPressed: () {},
              // ),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
