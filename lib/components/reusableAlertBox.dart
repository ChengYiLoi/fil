import 'package:fil/components/addButton.dart';
import 'package:fil/components/editGoalOptions.dart';
import 'package:fil/components/minusButton.dart';
import 'package:fil/components/recordGoalOptions.dart';
import 'package:flutter/material.dart';

class ReusableAlertBox extends StatefulWidget {
  const ReusableAlertBox({
    @required this.type,
    Key key,
  }) : super(key: key);
  final String type;

  @override
  _ReusableAlertBoxState createState() => _ReusableAlertBoxState();
}

class _ReusableAlertBoxState extends State<ReusableAlertBox> {
  int amount = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10),
      content: Container(
        height: 100,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        if (amount > 0) {
                          amount -= 50;
                        }
                      });
                    },
                    child: MinusButton()),
                Text(
                  "${amount.toString()}ml",
                  style: TextStyle(fontSize: 24),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        amount += 50;
                      });
                    },
                    child: AddButton())
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: widget.type == "edit"
                  ? EditGoalOptions(amount: amount)
                  : RecordGoalOptions(amount: amount),
            )
          ],
        ),
      ),
    );
  }
}
