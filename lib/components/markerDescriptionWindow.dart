import 'package:flutter/material.dart';

class MarkerDescriptionWindow extends StatelessWidget {
  const MarkerDescriptionWindow({
    Key key,
    @required this.descriptionWindowPosition,
    @required this.child,
  }) : super(key: key);

  final double descriptionWindowPosition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: descriptionWindowPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.topCenter,
        child: child,
      ),
    );
  }
}
