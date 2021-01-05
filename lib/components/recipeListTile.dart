import 'package:flutter/material.dart';

class RecipeListTile extends StatelessWidget {
  const RecipeListTile({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Container(
          child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child:
                Icon(Icons.fiber_manual_record, size: 16, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              "$text",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          )
        ],
      )),
    );
  }
}

// ListTile(
//         dense: true,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Icon(Icons.fiber_manual_record,size: 16,),
//         ),
//         title: Text(
//           "$text",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
