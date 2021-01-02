import 'package:flutter/material.dart';

class MarkerInfoWindow extends StatelessWidget {
  const MarkerInfoWindow({
    Key key,
    @required this.infoWindowPosition,
    @required this.child,
  }) : super(key: key);

  final double infoWindowPosition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: infoWindowPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }
}