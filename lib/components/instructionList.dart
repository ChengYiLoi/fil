import 'package:fil/components/components.dart';
import 'package:flutter/material.dart';

class InstructionList extends StatelessWidget {
  final List instructions;
  InstructionList({@required this.instructions});
  List<Widget> _renderList(List instructions) {
    List<RecipeListTile> output = [];
    instructions.forEach((instruction) {
      output.add(RecipeListTile(text: instruction));
    });
    return output;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _instructionList = _renderList(instructions);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Container(
        child: ListView(
          children: _instructionList,
        ),
      ),
    );
  }
}
