import 'package:flutter/material.dart';
import 'package:new_registreation1/global_variables.dart';

class RoundedImage extends StatefulWidget {
  final Size size;
  final String imagePath;

  const RoundedImage({
    Key key,
    this.size = const Size.fromWidth(120),
    this.imagePath,
  }) : super(key: key);

  @override
  _RoundedImageState createState() => _RoundedImageState();
}

class _RoundedImageState extends State<RoundedImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        widget.imagePath,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
