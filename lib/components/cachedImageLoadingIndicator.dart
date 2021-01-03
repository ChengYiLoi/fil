import 'package:flutter/material.dart';

class CachedImageLoadingIndicator extends StatelessWidget {
  const CachedImageLoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 2.0,
      valueColor:
          new AlwaysStoppedAnimation(Colors.blue),
    );
  }
}