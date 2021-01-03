import 'package:cached_network_image/cached_network_image.dart';
import 'package:fil/components/components.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatefulWidget {
  final Map<String, dynamic> recipeObj;
  final String id;
  final bool isFav;
  RecipeCard(
      {@required this.recipeObj, @required this.id, @required this.isFav});

  String get getId {
    return id;
  }

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  String imageUrl;
  bool opacity = false;
  getImageUrl(Reference ref) async {
    await ref.getDownloadURL().then((String url) {
      print("url is $url");
      setState(() {
        imageUrl = url;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    Reference ref =
        FirebaseStorage.instance.ref().child("recipeImages/${widget.id}.png");
    getImageUrl(ref);
    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        opacity = !opacity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: opacity ? 1.0 : 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4.0,
            child: Container(
              width: 160,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  imageUrl == null
                      ? SizedBox()
                      : ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: 160,
                            height: 180,
                            imageUrl: imageUrl,
                            placeholder: (context, _) => new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedImageLoadingIndicator()),
                            errorWidget: (context, _, __) =>
                                new Icon(Icons.error),
                          ),
                        ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 6.0),
                        child: Text("${widget.recipeObj['name']}"),
                      )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0, right: 6.0),
                        child: widget.isFav
                            ? Icon(
                                Icons.favorite,
                                color: Color(0xFFED6161),
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Color(0xFFC4C4C4),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
