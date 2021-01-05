import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fil/components/reusableRecipeCard.dart';
import 'package:fil/services/database.dart';
import 'package:flutter/material.dart';

class FavouriteRecipies extends StatefulWidget {
  final List recipeFavs;
  FavouriteRecipies({@required this.recipeFavs});
  @override
  _FavouriteRecipiesState createState() => _FavouriteRecipiesState();
}

class _FavouriteRecipiesState extends State<FavouriteRecipies> {
  DatabaseService _db;
  List<RecipeCard> _cards;
  @override
  void initState() {
    super.initState();
    _db = DatabaseService();
  }

  _renderCards(List<QueryDocumentSnapshot> documents) {
    List<RecipeCard> output = [];
    _cards = [];
    documents.forEach((document) {
      _cards.add(RecipeCard(
        recipeObj: document.data(),
        id: document.id,
        isFav: widget.recipeFavs.contains(document.id),
        key: Key(document.id),
      ));
    });
  }

  Future _blank() async {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.recipeFavs.length != 0
            ? _db.getFavRecipes(widget.recipeFavs)
            : _blank(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is QuerySnapshot) {
              _renderCards(snapshot.data.documents);
            } else {
              _cards = [];
            }
            return Scaffold(
                body: _cards.length != 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: _cards,
                            )
                          ],
                        ),
                      )
                    : Container(
                        child: Center(
                            child:
                                Text("You do not have any favourite recipes")),
                      ));
          } else {
            return Scaffold(
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }
}
