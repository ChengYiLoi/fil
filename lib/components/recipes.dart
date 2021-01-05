import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fil/components/reusableRecipeCard.dart';
import 'package:fil/services/database.dart';
import 'package:flutter/material.dart';

class Recipes extends StatefulWidget {
  final List<dynamic> recipeFavs;

  Recipes({@required this.recipeFavs});
  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  DatabaseService _db = DatabaseService();
  ScrollController _controller;
  List<RecipeCard> _cards;
  Future<QuerySnapshot> initialRecipes;
  bool isLoading;
  String lastRecipeId;

  @override
  void initState() {
    super.initState();
    _cards = [];
    _controller = ScrollController()..addListener(_scrollListener);
    initialRecipes = _db.getRecipes();
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _scrollListener() {
    print(_controller.position.extentAfter);
    if (!isLoading && _controller.position.extentAfter == 0) {
      String id = _cards[_cards.length - 1].getId;
      print("cards last id is $id");
      if (lastRecipeId != "") {
        if (id != lastRecipeId) {
          setState(() {
            isLoading = !isLoading;
            getAdditionalData(id);
          });
        }
      }
    }
  }

  void getAdditionalData(String id) async {
    print('query last id is $id');
    QuerySnapshot snapshot = await _db.getAdditionalRecipes(id);
    List<RecipeCard> newRecipeCards = [];

    List<DocumentSnapshot> documents = snapshot.docs;

    print('additional data length is ${documents.length}');
    documents.forEach((element) {
      print(element.id);
    });
    documents.forEach((document) {
      newRecipeCards.add(
        RecipeCard(
          recipeObj: document.data(),
          id: document.id,
          isFav: widget.recipeFavs.contains(
            document.id,

          ),
          key: Key(document.id),
        ),
      );
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _cards.addAll(newRecipeCards);
        isLoading = !isLoading;
      });
    });
  }

  void _renderInitialCards(List<DocumentSnapshot> documents) {
    print('render initial cards');
    List<RecipeCard> output = [];
   
      documents.forEach((document) {
        output.add(RecipeCard(
          recipeObj: document.data(),
          id: document.id,
          isFav: widget.recipeFavs.contains(document.id),
          key: Key(document.id),
        ));
      });
      _cards.addAll(output);
  }

  void getLastRecipeId() async {
    await _db.getLastRecipe().then((QuerySnapshot snapshot) {
      List<DocumentSnapshot> documents = snapshot.docs;
      lastRecipeId = documents[0].id;
      print("last id is $lastRecipeId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialRecipes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_cards.length == 0) {
              _renderInitialCards(snapshot.data.documents);
            }
            getLastRecipeId();
            return Scaffold(
              body: SingleChildScrollView(
                controller: _controller,
                child: Column(
                  children: [
                    Wrap(
                      children: _cards,
                    ),
                    isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(18),
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox()
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
