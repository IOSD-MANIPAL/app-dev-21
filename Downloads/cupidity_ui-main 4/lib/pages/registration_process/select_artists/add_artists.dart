

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../../global_variables.dart';
import '../../../models/Artist.dart';
import '../../Constants/colors.dart';


class AddArtists extends StatefulWidget {
  const AddArtists({Key key}) : super(key: key);

  @override
  _AddArtistsState createState() => _AddArtistsState();
}

class _AddArtistsState extends State<AddArtists> {
  int minCriteria = 15;
  // var temporaryuserPreferredArtists = userPreferredArtists;
  TextEditingController artistSearchcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    artistcontroller.addListener(scheduleRebuild);
    artistSearchcontroller.text = "";
  }

  @override
  void dispose() {
    artistcontroller.removeListener(scheduleRebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
//actual ui begins
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              heading(w),
              search(w, h),
              artistSelectionGrid(w, h),
            ],
          ),
          // continueButton(w, h),
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
            "Choose 15 or more artists you like",
            style: GoogleFonts.nunito(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 32,
                color: ThemeColor.notBlack,
              ),
            ),
          ),
          Text(
            "You can edit your choices later",
            textAlign: TextAlign.left,
            style: GoogleFonts.nunito(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: ThemeColor.notBlack.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container search(double w, double h) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: w * .04),
      height: h / 16,
      decoration: BoxDecoration(
        //  color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: artistSearchcontroller,
        onChanged: (value) {
          setState(() {
            temporaryuserPreferredArtists = relevantResultsArtists(
                artistSearchcontroller.text, userPreferredArtists);
            // print(userPreferredArtists);
            // temporaryuserPreferredArtists.map((e) => print(e.name));
          });
        },
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.search,
        enableSuggestions: true,
        style: GoogleFonts.nunito(
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ThemeColor.notBlack,
          ),
        ),
        cursorColor: ThemeColor.notBlack,
        cursorHeight: w * 0.06,
        cursorRadius: const Radius.circular(24),
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(width: 0.8, color: ThemeColor.notBlack),
          ),
          enabledBorder: OutlineInputBorder(
            gapPadding: 10,
            borderRadius: const BorderRadius.all(
              Radius.circular(24),
            ),
            borderSide: BorderSide(
              width: 0.4,
              color: ThemeColor.notBlack.withOpacity(.5),
            ),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: ThemeColor.notBlack,
          ),
          hintText: "Search for your favorite artists",
          hintStyle: GoogleFonts.nunito(
            textStyle: GoogleFonts.poppins(
              //  fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ThemeColor.notBlack.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }

  Container artistSelectionGrid(double w, double h) {
    // try {
    //   return Container(
    //     margin: EdgeInsets.all(w * 0.04),
    //     // height: h * 0.8,
    //     child: DragSelectGridView(
    //       //temporarily 6, can be changed later when we have the actual list
    //       itemCount: temporaryuserPreferredArtists.isEmpty
    //           ? 0
    //           : temporaryuserPreferredArtists.length < 100
    //               ? temporaryuserPreferredArtists.length
    //               : 100,
    //       shrinkWrap: true,
    //       triggerSelectionOnTap: true,
    //       gridController: artistcontroller,
    //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 2,
    //         crossAxisSpacing: w * 0.025,
    //         mainAxisSpacing: w * 0.05,
    //       ),
    //       itemBuilder: (context, index, selected) => SelectableItemWidget(
    //         name: temporaryuserPreferredArtists[index].name,
    //         url: temporaryuserPreferredArtists[index].image,
    //         isSelected: selected,
    //         artist: temporaryuserPreferredArtists[index],
    //       ),
    //     ),
    //   );
    // } catch (e) {
    //   return Container();
    // }
    try {
      return Container(
          margin: EdgeInsets.all(w * 0.04),
          height: h * 0.8,
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: w * 0.025,
              mainAxisSpacing: w * 0.05,
            ),
            children: [
              ...temporaryuserPreferredArtists.map(
                (e) => GridTile(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // e.isSelected = !e.isSelected;
                        if (e.isSelected == null) {
                          e.isSelected = true;
                        } else {
                          e.isSelected = !e.isSelected;
                        }

                        // print(selectedArtists.length);
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          // color: Colors.pink,
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: e.isSelected != true
                                  ? EdgeInsets.all(w * 0)
                                  : EdgeInsets.all(w * 0.015),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(e.image),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                margin: e.isSelected != true
                                    ? EdgeInsets.all(w * 0)
                                    : EdgeInsets.all(w * 0.015),
                                height: h / 20,
                                width:
                                    e.isSelected != true ? w * 0.45 : w * 0.42,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black38,
                                      Colors.black54,
                                      //Colors.black,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 0.5, 0.9],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom:
                                  e.isSelected == true ? w * 0.04 : w * 0.02,
                              left: e.isSelected == true ? w * 0.08 : w * 0.02,
                              child: Text(
                                //add the artist name here
                                '${e.name}',
                                overflow: TextOverflow.ellipsis, maxLines: 1,
                                //textScaleFactor: 1.1,
                                style: GoogleFonts.nunito(
                                  textStyle: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ));
    } catch (e) {
      return Container();
    }
  }

  List<Artist> relevantResultsArtists(searchTerm, List<Artist> searchartists) {
    if (searchTerm.length <= 0) {
      return searchartists;
    }

    return searchartists
        .where((item) =>
            item.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

//dont delete this function
  void scheduleRebuild() => setState(() {});
}
