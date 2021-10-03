import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectableGenreWidget extends StatefulWidget {
  final bool isSelected;
  final String name;
  final Color color;
  const SelectableGenreWidget(
      {Key key,
      @required this.isSelected,
      @required this.name,
      @required this.color})
      : super(key: key);

  @override
  _SelectableGenreWidgetState createState() => _SelectableGenreWidgetState();
}

class _SelectableGenreWidgetState extends State<SelectableGenreWidget>
    with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(SelectableGenreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        AnimatedBuilder(
          animation: scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: scaleAnimation.value,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: child,
                ),
              ],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            color: widget.color,
            child: Stack(
              children: [
                genreName(w),
              ],
            ),
          ),
        ),
        Positioned(
          right: w * 0.04,
          bottom: w * 0.04,
          child: Icon(Icons.check_circle_outline_rounded,
              size: 24,
              color: widget.isSelected ? Colors.white : Colors.transparent),
        ),
      ],
    );
  }

  Positioned genreName(double w) {
    return Positioned(
      top: w * 0.04,
      left: w * 0.04,
      child: Text(
        widget.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
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
}



 // Stack(
    //   children: [
    //     AnimatedBuilder(
    //       animation: scaleAnimation,
    //       builder: (context, child) => Transform.scale(
    //         scale: scaleAnimation.value,
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(20),
    //           child: child,
    //         ),
    //       ),
    //       child: Container(
    //         padding: const EdgeInsets.all(4),
    //         color: widget.color,
    //         child: genreName(w),
    //       ),
    //     ),
    //     //checkmark when user taps
    //     Positioned(
    //       right: w * 0.02,
    //       bottom: w * 0.02,
    //       child: Icon(Icons.check_circle_outline_rounded,
    //           size: 24,
    //           color: widget.isSelected ? Colors.white : Colors.transparent),
    //     ),
    //   ],
    // );