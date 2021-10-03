/*
This page collects song preference data.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';
import 'package:new_registreation1/pages/registration_process/new_registration_process/pages/artist_selection.dart';
import 'package:new_registreation1/pages/registration_process/select_artists/selectable_genre.dart';
import 'package:new_registreation1/pages/registration_process/select_artists/selectable_genre.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'components/custom_route.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';

import 'package:google_fonts/google_fonts.dart';
// import 'package:new_registreation1/pages/registration_process/select_artists/selectable_genre.dart';

import '../../../../global_variables.dart';
import 'name_age_gender.dart';

class GenreSelection extends StatefulWidget {
  const GenreSelection({Key key}) : super(key: key);

  @override
  _GenreSelectionState createState() => _GenreSelectionState();
}

class _GenreSelectionState extends State<GenreSelection>
    with SingleTickerProviderStateMixin {
  void scheduleRebuild() => setState(() {});
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..forward();
    genrecontroller.addListener(scheduleRebuild);
  }

  @override
  void dispose() {
    genrecontroller.removeListener(scheduleRebuild);
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
                    heading(w),
                    genreSelectionGrid(w, h),
                    const SizedBox(
                      height: 50,
                    )
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: CircularPercentIndicator(
        radius: 85,
        circularStrokeCap: CircularStrokeCap.round,
        lineWidth: 4.0,
        restartAnimation: true,
        animateFromLastPercent: true,
        animation: true,
        animationDuration: 500,
        percent: 4 / 7,
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
              if (genrecontroller.value.amount != 0) {
                selectedGenres = genrecontroller.value.selectedIndexes
                    .map((e) => genreNames[e].toString().toLowerCase())
                    .toList();
                setState(() {
                  userPreferredArtists = artists
                      .where(
                          (element) => selectedGenres.contains(element.genre))
                      .toList();

                  userPreferredArtists
                      .sort((a, b) => b.popularity.compareTo(a.popularity));
                  final names = userPreferredArtists.map((e) => e.name).toSet();
                  userPreferredArtists.retainWhere((x) => names.remove(x.name));
                });
                temporaryuserPreferredArtists = userPreferredArtists;
                Navigator.push(
                  context,
                  CustomMaterialPageRoute(
                    builder: (context) {
                      return const ArtistSelection();
                    },
                  ),
                );
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

  Widget genreSelectionGrid(double w, double h) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.02),
      child: DragSelectGridView(
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: genreNames.length,
        shrinkWrap: true,
        triggerSelectionOnTap: true,
        gridController: genrecontroller,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: w * 0.02,
          mainAxisSpacing: w * 0.05,
        ),
        itemBuilder: (context, index, selected) => SelectableGenreWidget(
          name: genreNames[index],
          color: colors[index],
          isSelected: selected,
        ),
      ),
    );
  }

  Padding heading(double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select your Favorite Genres",
            style: GoogleFonts.nunito(
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 32,
                color: ThemeColor.notBlack,
              ),
            ),
          ),
          Text(
            "You will be shown the top artists based on the genres you choose.",
            style: GoogleFonts.nunito(
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: ThemeColor.notBlack.withOpacity(0.8),
              ),
            ),
          ),
          Text(
            "You can always change it later :)",
            textAlign: TextAlign.left,
            style: GoogleFonts.nunito(
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: ThemeColor.notBlack.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content:
          Text("Select atleast 1 genre, so that we can show relevant artists!"),
    ));
  }
}
