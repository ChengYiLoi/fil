import 'package:flutter/material.dart';

class MinusButton extends StatelessWidget {
  const MinusButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.remove,
      size: 35,
    );
  }
}
