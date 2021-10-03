import 'package:flutter/material.dart';
import 'package:new_registreation1/pages/profile_page/style_guide/colors.dart';

class OpaqueImage extends StatefulWidget {
  final imageUrl;

  const OpaqueImage({Key key, @required this.imageUrl}) : super(key: key);

  @override
  _OpaqueImageState createState() => _OpaqueImageState();
}

class _OpaqueImageState extends State<OpaqueImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.network(
          widget.imageUrl,
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.fill,
        ),
        Container(
          color: primaryColorOpacity.withOpacity(0.85),
        ),
      ],
    );
  }
}
