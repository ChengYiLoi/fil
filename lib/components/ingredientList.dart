import 'package:flutter/material.dart';
import 'package:fil/components/components.dart';

class IngredientList extends StatelessWidget {
  final List ingredients;
  IngredientList({@required this.ingredients});
  List<Widget> _renderList(List ingredients) {
    List<RecipeListTile> output = [];
    ingredients.forEach((ingredient) {
      output.add(RecipeListTile(text: ingredient,));
    });
    return output;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _ingredientList = _renderList(ingredients);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Container(
        child: ListView(children: _ingredientList),
      ),
    );
  }
}

