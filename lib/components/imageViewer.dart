import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageViewer extends StatelessWidget {
  ImageViewer({
    @required this.imgUrl,
  });
  final String imgUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: Color(0xFF8FC1E3),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Center(
              child: Hero(
                  tag: "stationImg",
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => new CircularProgressIndicator(),
                    errorWidget: (context, _, __) => new Icon(Icons.error),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
