import 'package:fil/constants.dart';
import 'package:flutter/material.dart';

class NavbarIcon extends StatelessWidget {
  final String url;
  final Color navBarColor;

  NavbarIcon({this.url, this.navBarColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: navIconPadding,
      child: Image.asset(
        url,
        color: navBarColor,
      ),
    );
  }
}
