import 'package:cached_network_image/cached_network_image.dart';
import 'package:fil/constants.dart';
import 'package:flutter/material.dart';
import 'package:fil/components/components.dart';

class RecipeScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final String id;
  final String imageUrl;
  RecipeScreen(
      {@required this.recipe, @required this.id, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navBarBlue,
        toolbarHeight: appBarHeight,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Hero(
                  tag: id,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    errorWidget: (context, _, __) => new Icon(Icons.error),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 18.0, top: 12.0),
                      child: Icon(
                        Icons.favorite_border,
                        color: Color(0xFFC4C4C4),
                        size: 30.0,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "${recipe['name']}",
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
                                  ingredients: recipe['ingredients']),
                              InstructionList(
                                instructions: recipe['instructions'],
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
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
