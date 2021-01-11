import 'package:fil/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class RecordGoalOptions extends StatelessWidget {
  const RecordGoalOptions({
    this.amount,
    Key key,
  }) : super(key: key);
  final int amount;
  @override
  Widget build(BuildContext context) {
    final DatabaseService _db = Provider.of<DatabaseService>(context);
    final DateFormat formatter = DateFormat("yyyy-MM-dd");
    String now = formatter.format(DateTime.now());
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
                  color: Color(0xffF9B56A),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Cancel",
                style: popupButtonTextStyle,
              )),
        ),
        GestureDetector(
            onTap: () {
              print(amount);
              _db.addIntake(amount, now);
              Navigator.of(context).pop();
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xff8FC1E3),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 24.0),
                  child: Text(
                    "Record",
                    style: popupButtonTextStyle,
                  ),
                )))
      ],
    );
  }
}
