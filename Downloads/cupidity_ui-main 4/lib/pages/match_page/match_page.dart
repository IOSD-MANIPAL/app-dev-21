// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/global_variables.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';
import 'package:new_registreation1/pages/chat_page/chat_services.dart';
import 'package:new_registreation1/pages/error_pages/no_internet.dart';
import 'package:new_registreation1/pages/profile_page/profile_page.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../models/app_user.dart';
import '../error_pages/no_profiles_to_show.dart';
import '../chat_page/chat_page.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:like_button/like_button.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:http/http.dart' as http;
import 'custom_showcase.dart';

class MyHttpOverrides extends HttpOverrides {
  @override

  /// Checks for secure HTTP Connection.
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MatchPage2 extends StatefulWidget {
  const MatchPage2({Key key, @required this.newUser}) : super(key: key);
  final bool newUser;

  @override
  _MatchPage2State createState() => _MatchPage2State();
}

class _MatchPage2State extends State<MatchPage2> {
  bool _liked = false;
  int _currentImageIndex;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  List<PaletteColor> colors;
  List<AppUser> matchUsersForCurrentUser = [];
  AppUser currentAppUser;
  var currentMatchUserIndex = 0;
  bool isAllMatchUserDataLoaded = false;
  bool isCurrentAppUserDataLoaded = false;
  double _turns = 0;
  PageController matchPageController = PageController();
  bool allUsersDone = false;
  bool isLiked;
  bool isConnectedToInternet = true;
  //keys for feature discovery
  final nextImageKey = GlobalKey();
  final messagesKey = GlobalKey();
  final refreshKey = GlobalKey();
  final profileKey = GlobalKey();
  final likeKey = GlobalKey();
  final previousImageKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    initializeNewMatchConversations(); //Start a conversation with all new matches
    user = auth.currentUser;
    _liked = false;
    _currentImageIndex = 0;
    colors = [];
    checkConnectivity();
    getCurrentAppUserData().then((value) {
      getPotentialMatchDataForCurrentUser().then((value) {
        _updatePalettes(matchUsersForCurrentUser[currentMatchUserIndex].images);
        updateMatchPercentage();
      });
    });
    //initialising the feature discovery feature
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ShowCaseWidget.of(context).startShowCase([
              profileKey,
              messagesKey,
              likeKey,
              refreshKey,
              nextImageKey,
              previousImageKey,
            ]));
  }

//ACTUAL UI OF THE SCREEN
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(context),
      body: isConnectedToInternet == true
          ? isAllMatchUserDataLoaded == true && allUsersDone == false
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GestureDetector(
                      onDoubleTap: toggleLikeDislike,
                      child: images(),
                    ),
                    blackGradient(h, w),
                    bottomInfo(h, w),
                  ],
                )
              : NoProfilesToShowPage()
          : const NoInternetConnectionPage(),
    );
  }

//METHODS
  void toggleLikeDislike() {
    setState(() {
      _liked = !_liked;
    });
  }

  checkConnectivity() async {
    var connectionStatus = await Connectivity().checkConnectivity();
    if (connectionStatus == ConnectivityResult.none) {
      setState(() {
        isConnectedToInternet = false;
      });
    } else {
      setState(() {
        isConnectedToInternet = true;
      });
    }
  }

  updateMatchPercentage() {
    for (var matchUser in matchUsersForCurrentUser) {
      double matchPercentage = 0;
      for (var x in matchUser.favArtists) {
        for (var y in currentAppUser.favArtists) {
          if (x["name"] == y["name"]) {
            matchPercentage += 1;
          }
        }
      }

      int minn =
          min(currentAppUser.favArtists.length, matchUser.favArtists.length);
      int maxx =
          max(currentAppUser.favArtists.length, matchUser.favArtists.length);
      if (minn == 0) {
        matchPercentage = 0;
      } else {
        matchPercentage = (matchPercentage / (minn - (minn / maxx)) * 100);
      }
      setState(() {
        if (matchPercentage > 100) {
          matchUser.matchPercent = 99;
        } else {
          matchUser.matchPercent = matchPercentage;
        }
      });
      print("Match Percentage: $matchPercentage");
    }
  }

  _updatePalettes(images) async {
    for (String image in images) {
      final PaletteGenerator generator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(image),
        size: const Size(50, 25),
      );
      print(generator.colors);
      colors.add(
        (generator.lightMutedColor ?? PaletteColor(Colors.pink.shade100, 2)),
      );
    }

    setState(() {});
  }

  Future getPotentialMatchDataForCurrentUser() async {
    try {
      user = auth.currentUser;
      var res = json.encode({
        "client_id": user.uid,
      });
      final response = await http.post(
        Uri.parse(
            "https://cupidity-api.herokuapp.com/users/fetchUsersForClient/?API_KEY=CUPIDITY"),
        body: res,
        headers: {"Content-Type": "application/json"},
      );

      var responseData = json.decode(response.body);
      for (var singleMatchUserData in responseData) {
        bool dislikedUser = false;
        for (var d in currentAppUser.dislikes) {
          if (d["_id"] == singleMatchUserData["_id"]) {
            dislikedUser = true;
            break;
          }
        }
        if (dislikedUser == false &&
            singleMatchUserData["cached_age"] <= currentAppUser.ageMaxPref &&
            singleMatchUserData["cached_age"] >= currentAppUser.ageMinPref) {
          AppUser singleMatchUser = AppUser(
            age: singleMatchUserData["cached_age"],
            name: singleMatchUserData["name"],
            ageMaxPref: singleMatchUserData["age_pref"]["age_max"],
            ageMinPref: singleMatchUserData["age_pref"]["age_min"],
            bio: singleMatchUserData["bio"],
            images: singleMatchUserData["images"],
            gender: singleMatchUserData["gender"],
            genderPref: singleMatchUserData["gender_pref"],
            uid: singleMatchUserData["_id"],
            favArtists: singleMatchUserData["fav_artists"],
          );

          setState(() {
            matchUsersForCurrentUser.add(singleMatchUser);
            isAllMatchUserDataLoaded = true;
          });
        }
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  getCurrentAppUserData() async {
    try {
      user = auth.currentUser;
      var res = json.encode({
        "target_id": user.uid,
      });
      final response = await http.post(
        Uri.parse(
            "https://cupidity-api.herokuapp.com/users/fetchUser/?API_KEY=CUPIDITY"),
        body: res,
        headers: {"Content-Type": "application/json"},
      );

      var responseData = json.decode(response.body);
      // print(responseData);

      if (responseData != null) {
        setState(() {
          currentAppUser = AppUser(
            age: responseData["cached_age"],
            name: responseData["name"],
            ageMaxPref: responseData["age_pref"]["age_max"],
            ageMinPref: responseData["age_pref"]["age_min"],
            bio: responseData["bio"],
            images: responseData["images"],
            profile: responseData["images"][0],
            gender: responseData["gender"],
            genderPref: responseData["gender_pref"],
            uid: responseData["_id"],
            dob: responseData["dob"],
            likedBy: responseData["meta"]["user_liked_by"],
            matches: responseData["meta"]["user_matches"],
            dislikes: responseData["meta"]["user_dislikes"],
            favArtists: responseData["fav_artists"],
          );
          isCurrentAppUserDataLoaded = true;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  updateLikeForUser() async {
    var responseData;
    String apiUpdateLikedUsers =
        "https://cupidity-api.herokuapp.com/users/updateUserLikesAndMatches/?API_KEY=CUPIDITY";
    print(currentAppUser.uid);
    var res = json.encode({
      "client_id": currentAppUser.uid,
      "target_id": matchUsersForCurrentUser[currentMatchUserIndex].uid,
    });
    print(res);
    try {
      final response = await http.patch(
        Uri.parse(apiUpdateLikedUsers),
        body: res,
        headers: {"Content-Type": "application/json"},
      );
      responseData = json.decode(response.body);
      print("$responseData");
    } catch (e) {
      print(e);
    }
    if (responseData != null) {
      setState(() {
        if (currentMatchUserIndex != matchUsersForCurrentUser.length - 1) {
          print(currentMatchUserIndex);
          currentMatchUserIndex++;
          _updatePalettes(
              matchUsersForCurrentUser[currentMatchUserIndex].images);
        } else {
          allUsersDone = true;
          print(allUsersDone);
        }
        _currentImageIndex = 0;
      });
    }
    setState(() {
      _liked = !_liked;
    });
  }

  updateDislikeForUser() async {
    var responseData;
    String apiUpdateDislikedUsers =
        "https://cupidity-api.herokuapp.com/users/updateUserDislikes/?API_KEY=CUPIDITY";
    print(currentAppUser.uid);
    var res = json.encode({
      "client_id": currentAppUser.uid,
      "target_id": matchUsersForCurrentUser[currentMatchUserIndex].uid,
    });
    print(res);
    try {
      final response = await http.patch(
        Uri.parse(apiUpdateDislikedUsers),
        body: res,
        headers: {"Content-Type": "application/json"},
      );
      responseData = json.decode(response.body);
      print("$responseData");
    } catch (e) {
      print(e);
    }
    if (responseData != null) {
      setState(() {
        if (currentMatchUserIndex != matchUsersForCurrentUser.length - 1) {
          print(currentMatchUserIndex);
          currentMatchUserIndex++;
          _updatePalettes(
              matchUsersForCurrentUser[currentMatchUserIndex].images);
        } else {
          allUsersDone = true;
          print(allUsersDone);
        }
        _currentImageIndex = 0;
      });
    }
  }

/*
-----UI ELEMENTS----- 
*/

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: widget.newUser
          ? showcaseProfileButton(context)
          : profileButton(context),
      centerTitle: true,
      title: appName(),
      actions: [
        widget.newUser
            ? showcaseMessageButton(context)
            : messageButton(context),
      ],
    );
  }

  Widget showcaseProfileButton(BuildContext context) {
    return CustomShowCase(
      description: 'See your profile',
      globalKey: profileKey,
      child: profileButton(context),
    );
  }

  IconButton profileButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (isCurrentAppUserDataLoaded == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                appUser: currentAppUser,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Please wait for a moment before trying again")));
        }
      },
      icon: Icon(
        FontAwesomeIcons.user,
        color: colors.isNotEmpty
            ? colors[_currentImageIndex].color
            : ThemeColor.pinkish,
      ),
    );
  }

  Text appName() {
    return Text(
      "Cupidity",
      style: GoogleFonts.pacifico(
        textStyle: TextStyle(
            color: colors.isNotEmpty
                ? colors[_currentImageIndex].color
                : ThemeColor.pinkish,
            letterSpacing: .5),
      ),
    );
  }

  Widget showcaseMessageButton(BuildContext context) {
    return CustomShowCase(
      globalKey: messagesKey,
      description: "See all your matches and chats here",
      child: messageButton(context),
    );
  }

  IconButton messageButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MessagePage()),
      ),
      icon: Icon(
        FontAwesomeIcons.comments,
        color: colors.isNotEmpty
            ? colors[_currentImageIndex].color
            : ThemeColor.pinkish,
      ),
    );
  }

  bottomInfo(double h, double w) {
    return Container(
      height: h * 0.36,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pageIndicator(),
                  userNameBioLikeButton(h, w),
                  percentage(h, w),
                  mediaButtons(h, w),
                  coloredBox(h, w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PageView images() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: matchPageController,
      onPageChanged: (index) {
        setState(() {
          _liked = !_liked;
        });
      },
      pageSnapping: true,
      children: [
        ...matchUsersForCurrentUser[currentMatchUserIndex]
            .images
            .map((e) => AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                          child: Lottie.asset(
                              "assets/animations/music_animation.json",
                              fit: BoxFit.fitWidth)),
                      FadeInImage.memoryNetwork(
                        fadeInCurve: Curves.easeInOutQuad,
                        fadeInDuration: const Duration(milliseconds: 250),
                        placeholder: kTransparentImage,
                        image: e,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                )),
      ],
    );
  }

  Padding pageIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: AnimatedSmoothIndicator(
        activeIndex: _currentImageIndex, // PageController
        count: matchUsersForCurrentUser[currentMatchUserIndex].images.length,
        effect: const SwapEffect(
          dotHeight: 4,
          dotWidth: 4,
          type: SwapType.yRotation,
          activeDotColor: ThemeColor.pinkish,
        ),
      ),
    );
  }

  Container blackGradient(double h, double w) {
    return Container(
      height: (h / w == 16 / 9) ? h * 0.33 : h * 0.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black54,
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.3, 2.0],
        ),
      ),
    );
  }

  AspectRatio userImage(String s) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Image.network(
        s,
        fit: BoxFit.cover,
      ),
    );
  }

  Padding mediaButtons(double h, double w) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.newUser
              ? showcasePreviousPictureButton()
              : previousPictureButton(),
          widget.newUser ? showaseNextUserButton() : nextUserButton(),
          widget.newUser ? showcaseNextPictureButton() : nextPictureButton(),
        ],
      ),
    );
  }

  CustomShowCase showcaseNextPictureButton() {
    return CustomShowCase(
      globalKey: nextImageKey,
      description: "Tap to see the next image ",
      child: nextPictureButton(),
    );
  }

  CustomShowCase showaseNextUserButton() {
    return CustomShowCase(
      globalKey: refreshKey,
      description: "Tap to pass and see the next person",
      child: nextUserButton(),
    );
  }

  CustomShowCase showcasePreviousPictureButton() {
    return CustomShowCase(
      globalKey: previousImageKey,
      description: "Tap to see the previous image",
      child: previousPictureButton(),
    );
  }

  IconButton nextPictureButton() {
    return IconButton(
      icon: const Icon(
        FontAwesomeIcons.stepForward,
        color: Colors.white,
      ),
      onPressed: () {
        if (_currentImageIndex !=
            matchUsersForCurrentUser[currentMatchUserIndex].images.length - 1) {
          setState(() {
            _currentImageIndex++;
            matchPageController.animateToPage(
              _currentImageIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        }
      },
    );
  }

  AnimatedRotation nextUserButton() {
    return AnimatedRotation(
      duration: const Duration(seconds: 1, milliseconds: 500),
      curve: Curves.easeInOutCubicEmphasized,
      alignment: Alignment.center,
      turns: _turns,
      child: IconButton(
        icon: const Icon(
          FontAwesomeIcons.syncAlt,
          size: 35,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _turns += 3.5;
            updateDislikeForUser();
          });
        },
      ),
    );
  }

  IconButton previousPictureButton() {
    return IconButton(
      icon: const Icon(
        FontAwesomeIcons.stepBackward,
        color: Colors.white,
      ),
      onPressed: () {
        if (_currentImageIndex != 0) {
          setState(() {
            _currentImageIndex--;
            matchPageController.animateToPage(
              _currentImageIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        }
      },
    );
  }

  Container percentage(double h, double w) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: LinearPercentIndicator(
              percent:
                  matchUsersForCurrentUser[currentMatchUserIndex].matchPercent /
                              100 >
                          1.0
                      ? 1.0
                      : matchUsersForCurrentUser[currentMatchUserIndex]
                              .matchPercent /
                          100,
              animateFromLastPercent: true,
              animation: true,
              lineHeight: 4,
              progressColor: const Color(0XffFE3782),
              backgroundColor: const Color(0xffC4C4C4),
              animationDuration: 500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${matchUsersForCurrentUser[currentMatchUserIndex].matchPercent.round() > 100 ? 100 : matchUsersForCurrentUser[currentMatchUserIndex].matchPercent.round()}% match",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Row userNameBioLikeButton(double h, double w) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  style: GoogleFonts.poppins(
                    textStyle: GoogleFonts.poppins(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    TextSpan(
                      text:
                          matchUsersForCurrentUser[currentMatchUserIndex].name,
                    ),
                    const TextSpan(text: ", "),
                    TextSpan(
                        text:
                            "${matchUsersForCurrentUser[currentMatchUserIndex].age}")
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showBioExtended(h, w);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${matchUsersForCurrentUser[currentMatchUserIndex].bio}",
                  style: GoogleFonts.poppins(
                    textStyle: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        widget.newUser ? showcaseLikeButton(w) : likeButton(w),
      ],
    );
  }

  CustomShowCase showcaseLikeButton(double w) {
    return CustomShowCase(
      globalKey: likeKey,
      description:
          "You can either tap here or double tap on the image to like this profile",
      child: likeButton(w),
    );
  }

  InkWell likeButton(double w) {
    return InkWell(
      onTap: () {
        print("SingleTapped");
        setState(() {
          _liked = !_liked;
        });
        updateLikeForUser();
      },
      child: LikeButton(
        size: w * 0.125,
        animationDuration: const Duration(seconds: 1),
        isLiked: _liked,
      ),
    );
  }

  showBioExtended(double h, double w) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        )),
        builder: (context) {
          return SizedBox(
            height: h * 0.25,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: w * 0.05,
                    left: w * 0.1,
                    right: w * 0.1,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.lato(
                        textStyle: GoogleFonts.poppins(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        TextSpan(
                          style: GoogleFonts.lato(),
                          text: matchUsersForCurrentUser[currentMatchUserIndex]
                              .name,
                        ),
                        const TextSpan(text: "'s Bio"),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(w * 0.1),
                  // height: h * 0.4,
                  child: Text(
                    "${matchUsersForCurrentUser[currentMatchUserIndex].bio}",
                    style: GoogleFonts.lato(
                      textStyle: GoogleFonts.poppins(
                        fontSize: 18,
                        // color: colors[_currentImageIndex].bodyTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Container coloredBox(double h, double w) {
    return Container(
        width: w * 0.9,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colors.isNotEmpty
              ? colors[_currentImageIndex].color
              : Theme.of(context).primaryColor,
        ),
        child: Column(
          children: [
            topArtistsTitle(),
            favoriteArtistsWrap(),
          ],
        ));
  }

  Padding topArtistsTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Text(
        "${matchUsersForCurrentUser[currentMatchUserIndex].name}'s Top Artists",
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
          textStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colors.isNotEmpty
                  ? colors[_currentImageIndex].bodyTextColor
                  : Colors.black),
        ),
      ),
    );
  }

  Wrap favoriteArtistsWrap() {
    return Wrap(
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      children: [
        ...matchUsersForCurrentUser[currentMatchUserIndex].favArtists.map(
              (e) => spotifyPill(e["image"], e["name"], e["uri"]),
            ),
      ],
    );
  }

  UnconstrainedBox spotifyPill(
    String url,
    String artist,
    String uri,
  ) {
    return UnconstrainedBox(
      child: InkWell(
        onTap: () {
          launchURL(uri);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
              border: Border.all(
                  color: colors.isNotEmpty
                      ? colors[_currentImageIndex].bodyTextColor
                      : Colors.black,
                  width: 1),
              borderRadius: BorderRadius.circular(24)),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(url),
                radius: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  artist,
                  style: GoogleFonts.poppins(
                    textStyle: GoogleFonts.poppins(
                        color: colors.isNotEmpty
                            ? colors[_currentImageIndex].bodyTextColor
                            : Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

