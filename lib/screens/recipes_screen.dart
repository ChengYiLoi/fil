
import 'package:fil/components/favouriteRecipes.dart';
import 'package:fil/components/recipes.dart';
import 'package:fil/constants.dart';
import 'package:fil/models/user.dart';
import 'package:fil/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  UserObj _userObj;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService _db =
        Provider.of<DatabaseService>(context, listen: false);
    return StreamBuilder(
      stream: _db.queryUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _userObj = snapshot.data;
          return DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: navBarBlue,
                toolbarHeight: 60,
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text("All"),
                    ),
                    Tab(
                      child: Text("My Favourites"),
                    )
                  ],
                ),
              ),
              body: TabBarView(children: [
                Recipes(
                  recipeFavs: _userObj.recipeFavs,
                ),
                FavouriteRecipies(
                  recipeFavs: _userObj.recipeFavs,
                )
              ]),
            ),
          );
        } else {
          return Scaffold(
            body: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
