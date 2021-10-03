import 'package:flutter/material.dart';

//Overrides the transition on material page route
class CustomMaterialPageRoute<T> extends MaterialPageRoute<T> {
  CustomMaterialPageRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}