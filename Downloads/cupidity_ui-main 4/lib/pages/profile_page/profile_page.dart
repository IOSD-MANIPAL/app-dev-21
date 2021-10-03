import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/global_variables.dart';
import 'package:new_registreation1/models/app_user.dart';

import 'package:new_registreation1/pages/profile_page/edit_profile.dart';
import 'package:new_registreation1/pages/settings.dart';

import 'commons/my_info.dart';

import 'package:line_icons/line_icons.dart';

class ProfilePage extends StatefulWidget {
  final AppUser appUser;

  const ProfilePage({Key key, this.appUser}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState(appUser);
}

class _ProfilePageState extends State<ProfilePage> {
  bool circular = true;
  final AppUser appUser;
  _ProfilePageState(this.appUser);

  @override
  void initState() {
    super.initState();

    appUser.printDetails();
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: profileAppBar(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyInfo(
              appUser: appUser,
            ),
            buildPicturesAndAlbumContainersAndText()
          ],
        ),
      ),
    );
  }

  AppBar profileAppBar(BuildContext context) {
    return AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded),
            color: Colors.black),
        actions: [
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              icon: const Icon(Icons.more_vert_rounded, color: Colors.black),
              elevation: 5,
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(
                          LineIcons.userEdit,
                          size: 24,
                        ),
                        title: const Text("Edit Profile"),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(
                                  appUser: appUser,
                                ),
                              ));
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(
                          Icons.settings_outlined,
                          size: 24,
                        ),
                        title: const Text("Settings"),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsPage()));
                        },
                      ),
                    ),
                  ])
        ]);
  }

  Container buildPicturesAndAlbumContainersAndText() {
    return Container(
        padding: const EdgeInsets.only(top: 32, left: 18.0),
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "My Pictures",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // buildAlbums()
            SizedBox(
              // height: 200,
              height: MediaQuery.of(context).size.height / 5,
              // width: MediaQuery.of(context).size.width / 4,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...appUser.images.map((e) => buildAlbums(e)),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "My Favorite Artists",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            // buildAlbums()
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...appUser.favArtists.map((e) => buildArtists(e)),
                ],
              ),
            )
          ],
        ));
  }

  Row buildAlbums(image) {
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              // height: 300,
              // height: MediaQuery.of(context).size.height / 4,
              // width: MediaQuery.of(context).size.width / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  image,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildArtists(e) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            print(e["uri"]);
            launchURL(e["uri"]);
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                e["image"],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
