import 'package:cached_network_image/cached_network_image.dart';
import 'package:fil/components/components.dart';
import 'package:fil/constants.dart';
import 'package:fil/screens/recipe_screen.dart';
import 'package:fil/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatefulWidget {
  final Map<String, dynamic> recipeObj;
  final String id;
  final bool isFav;

  RecipeCard(
      {@required this.recipeObj,
      @required this.id,
      @required this.isFav,
      @required Key key})
      : super(key: key);

  String get getId {
    return id;
  }

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  DatabaseService _db;
  String imageUrl;
  bool opacity = false;
  bool isFavIcon;
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
    isFavIcon = widget.isFav;
    _db = DatabaseService();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("recipeImages/${widget.recipeObj['imageUrl']}.png");
    getImageUrl(ref);
    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        opacity = !opacity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => RecipeScreen(
              recipe: widget.recipeObj,
              id: widget.id,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: opacity ? 1.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4.0,
              child: Container(
                width: 160,
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    imageUrl == null
                        ? SizedBox()
                        : Hero(
                            tag: widget.id,
                            child: ClipRRect(
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
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              String operation = 'add';
                              if (isFavIcon) {
                                operation = 'delete';
                              }
                              isFavIcon = !isFavIcon;
                              _db.updateFavRecipe(widget.id, operation);
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 6.0, right: 6.0),
                            child:
                                isFavIcon ? filledFavourite : unfilledFavourite,
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
      ),
    );
  }
}
