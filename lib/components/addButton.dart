import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.add,
      size: 35,
    );
  }
}
