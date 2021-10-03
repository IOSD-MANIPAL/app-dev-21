import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';
import 'package:new_registreation1/pages/registration_process/select_artists/selectable_genre.dart';

import '../../../global_variables.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({Key key}) : super(key: key);

  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  //colors

  final List<Color> colors = [
    const Color(0xff268469),
    const Color(0xff1d3362),
    const Color(0xff8b68aa),
    const Color(0xffe71159),
    const Color(0xffaf2795),
    const Color(0xffa56752),
    const Color(0xff538007),
    const Color(0xff8a1a32),
    const Color(0xfffc4630),
    const Color(0xff2d46ba),
    const Color(0xff467e95),
    const Color(0xff268469),
    const Color(0xff1d3362),
    const Color(0xff8b68aa),
    const Color(0xffe71159),
    const Color(0xffaf2795),
    const Color(0xffa56752),
    const Color(0xff538007),
    const Color(0xff8a1a32),
    const Color(0xfffc4630),
    const Color(0xff2d46ba),
    const Color(0xff467e95),
    const Color(0xff268469),
    const Color(0xff1d3362),
    const Color(0xff1d3362),
    const Color(0xff8b68aa),
    const Color(0xffe71159),
    const Color(0xffaf2795),
  ];
  // bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    genrecontroller.addListener(scheduleRebuild);
  }

  @override
  void dispose() {
    genrecontroller.removeListener(scheduleRebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    Widget continueButton(double w, double h) {
      if (genrecontroller.value.amount >= minCriteria) {
        // return Positioned(
        //   bottom: w * 0.02,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       primary: maroon,
        //       elevation: 25,
        //       fixedSize: Size(w * 0.5, h / 16),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //     ),
        //     onPressed: () {
        //       print("Colors: ${colors.length}");
        //       print("Genres: ${genreNames.length}");
        //       //this is a list of all  the genre names selected.
        //       final selectedGenres = genrecontroller.value.selectedIndexes
        //           .map((e) => genreNames[e])
        //           .toList();
        //       print(selectedGenres);
        //     },
        //     child: Text("CONTINUE",
        //         style: GoogleFonts.nunito(
        //             textStyle: GoogleFonts.poppins(
        //           letterSpacing: 1,
        //           fontSize: 18,
        //           fontWeight: FontWeight.w500,
        //           color: Colors.white,
        //         ))),
        //   ),
        // );
        return const Offstage();
      } else {
        return Positioned(
          bottom: 0,
          child: Material(
            color: ThemeColor.maroon,
            elevation: 25,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Container(
              height: h / 16,
              alignment: Alignment.center,
              width: w,
              padding:
                  EdgeInsets.symmetric(vertical: 0.02, horizontal: w * 0.04),
              child: Text(
                "Select atleast one genre",
                style: GoogleFonts.nunito(
                  textStyle: GoogleFonts.poppins(
                    letterSpacing: 0.2,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

//actual ui begins
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
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
          continueButton(w, h),
        ],
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

  Widget genreSelectionGrid(double w, double h) {
    return Container(
      margin: EdgeInsets.all(w * 0.04),
      // height: h * 0.8,
      child: DragSelectGridView(
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

  void scheduleRebuild() => setState(() {});
}
