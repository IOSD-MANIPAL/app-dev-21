import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/global_variables.dart';
import 'package:new_registreation1/models/Artist.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';

class SelectableItemWidget extends StatefulWidget {
  final String url;
  final bool isSelected;
  final String name;
  final Artist artist;
  const SelectableItemWidget({
    Key key,
    @required this.url,
    @required this.isSelected,
    @required this.name,
    @required this.artist,
  }) : super(key: key);

  @override
  _SelectableItemWidgetState createState() => _SelectableItemWidgetState();
}

class _SelectableItemWidgetState extends State<SelectableItemWidget>
    with SingleTickerProviderStateMixin {
  //colors
  Color notBlack = const Color(0xff2F2E41);
  Color pinkish = const Color(0xffFE3782);
  Color maroon = const Color(0xffDA2753);
  Color shadow = const Color(0xffBDBFC0);
  AnimationController animationController;
  Animation<double> scaleAnimation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      value: widget.isSelected ? 1 : 0,
      vsync: this,
      duration: kThemeAnimationDuration,
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutCirc),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SelectableItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        if (selectedArtists.contains(widget.artist) == false) {
          selectedArtists.add(widget.artist);
          // selectedArtists.map((e) => print(e.name));
          for (var s in selectedArtists) {
            print(s.name + " ");
          }
        }
        animationController.forward();
      } else {
        if (selectedArtists.contains(widget.artist) == true) {
          selectedArtists.remove(widget.artist);
          // selectedArtists.map((e) => print(e.name));
          for (var s in selectedArtists) {
            print(s.name + " ");
          }
        }
        animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        selectedArtists.contains(widget.artist) == true
            ? selectedIndicator(w)
            : const Offstage(),
        // selectedIndicator(w),
        AnimatedBuilder(
          animation: scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: scaleAnimation.value,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(widget.isSelected ? 20 : 20),
                  child: child,
                ),
              ],
            ),
          ),
          child: Stack(
            children: [artistPicture(), blackGradient(h, w), artistName(w)],
          ),
        ),
      ],
    );
  }

  Container selectedIndicator(double w) {
    return Container(
      margin: EdgeInsets.all(w * 0.005),
      decoration: BoxDecoration(
        color: ThemeColor.maroon,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Positioned artistPicture() {
    if (widget.url != "") {
      return Positioned.fill(
        child: Image.network(
          widget.url,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Positioned.fill(
        child: Center(
          child: Text("${widget.name[0]}"),
        ),
      );
    }
  }

  Positioned artistName(double w) {
    return Positioned(
      bottom: widget.isSelected ? w * 0.04 : w * 0.02,
      left: widget.isSelected ? w * 0.08 : w * 0.02,
      child: Text(
        widget.name,
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
    );
  }

  Positioned blackGradient(double h, double w) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: h / 20,
        width: w * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
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
    );
  }
}
