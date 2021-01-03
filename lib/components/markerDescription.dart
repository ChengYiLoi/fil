import 'package:flutter/material.dart';

class MarkerDescription extends StatelessWidget {
  const MarkerDescription({
    Key key,
    this.markerDescription,
  }) : super(key: key);
  final String markerDescription;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                offset: Offset.zero,
                color: Colors.grey.withOpacity(0.5)),
          ]),
      width: 200,
      height: 80,
      child: Center(child: Text(markerDescription)),
    );
  }
}