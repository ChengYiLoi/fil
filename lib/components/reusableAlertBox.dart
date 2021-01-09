import 'package:fil/components/addButton.dart';
import 'package:fil/components/editGoalOptions.dart';
import 'package:fil/components/minusButton.dart';
import 'package:fil/components/recordGoalOptions.dart';
import 'package:flutter/material.dart';

class ReusableAlertBox extends StatefulWidget {
  const ReusableAlertBox({
    @required this.type,
    @required this.isMetric,
    Key key,
  }) : super(key: key);
  final String type;
  final bool isMetric;

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
                          amount -= widget.isMetric ? 50 : 1;
                        }
                      });
                    },
                    child: MinusButton()),
                Text(
                  "${amount.toString()} ${widget.isMetric ? "ml" : "oz"}",
                  style: TextStyle(fontSize: 24),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        amount += widget.isMetric ? 50 : 1;
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
