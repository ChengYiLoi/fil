import 'package:fil/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fil/constants.dart';
import 'package:provider/provider.dart';

class EditGoalOptions extends StatelessWidget {
  const EditGoalOptions({
    @required this.amount,
    Key key,
  }) : super(key: key);
  final int amount;

  @override
  Widget build(BuildContext context) {
    final DatabaseService _db = Provider.of<DatabaseService>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              decoration: BoxDecoration(
                  color: buttonOrange, borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Cancel",
                style: popupButtonTextStyle,
              )),
        ),
        GestureDetector(
            onTap: () {
              
              _db.editGoal(amount);
              Navigator.of(context).pop();
            },
            child: Container(
                decoration: BoxDecoration(
                    color: buttonBlue, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 24.0),
                  child: Text(
                    "Update",
                    style: popupButtonTextStyle,
                  ),
                )))
      ],
    );
  }
}
