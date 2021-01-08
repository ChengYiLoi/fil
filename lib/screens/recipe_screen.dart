import 'package:cached_network_image/cached_network_image.dart';
import 'package:fil/constants.dart';
import 'package:fil/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fil/components/components.dart';
import 'package:provider/provider.dart';

class RecipeScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final String id;
  final String imageUrl;
  final bool isFav;
  final VoidCallback onFavChange;
  RecipeScreen({
    @required this.recipe,
    @required this.id,
    @required this.imageUrl,
    @required this.isFav,
    @required this.onFavChange,
  });

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isFavIcon;
  DatabaseService _db;
  @override
  void initState() {
    isFavIcon = widget.isFav;
    _db = Provider.of<DatabaseService>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.imageUrl);
    print(widget.imageUrl.contains("noImage.png"));
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: navBarBlue,
        //   toolbarHeight: appBarHeight,
        // ),
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Hero(
                      tag: widget.id,
                      child: CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        imageUrl: widget.imageUrl,
                        errorWidget: (context, _, __) => new Icon(Icons.error),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        String operation = 'like';
                        if (isFavIcon) {
                          operation = 'dislike';
                        }
                        _db.updateFavRecipe(widget.id, operation);
                        setState(() {
                          widget.onFavChange();
                          isFavIcon = !isFavIcon;
                        });
                      },
                      child: Padding(
                          padding:
                              const EdgeInsets.only(right: 18.0, top: 12.0),
                          child:
                              isFavIcon ? filledFavourite : unfilledFavourite),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "${widget.recipe['name']}",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Expanded(
                    child: DefaultTabController(
                        length: 2,
                        initialIndex: 0,
                        child: Container(
                            child: Column(
                          children: [
                            TabBar(
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: buttonBlue,
                              tabs: [
                                Tab(
                                  child: Text(
                                    "Ingredients",
                                  ),
                                ),
                                Tab(
                                  child: Text("Instructions"),
                                )
                              ],
                            ),
                            Expanded(
                              child: TabBarView(children: [
                                IngredientList(
                                    ingredients: widget.recipe['ingredients']),
                                InstructionList(
                                  instructions: widget.recipe['instructions'],
                                )
                              ]),
                            )
                          ],
                        ))),
                  )
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: widget.imageUrl.contains("noImage.png") ? Colors.grey : Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
