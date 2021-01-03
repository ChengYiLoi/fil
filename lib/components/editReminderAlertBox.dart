import 'package:fil/components/reusableReminderInputCard.dart';
import 'package:fil/constants.dart';
import 'package:fil/services/database.dart';
import 'package:flutter/material.dart';

class EditReminderAlertBox extends StatefulWidget {
  final String time;
  final String amount;
  EditReminderAlertBox({@required this.time, @required this.amount});
  @override
  _EditReminderAlertBoxState createState() => _EditReminderAlertBoxState();
}

class _EditReminderAlertBoxState extends State<EditReminderAlertBox> {
  String _time;
  String _amount;
  String _oldTime;
  String _oldAmount;
  DatabaseService _db = DatabaseService();
  formatTime(Duration time) => time
      .toString()
      .split(".")
      .first
      .padLeft(8, "0")
      .split("")
      .sublist(0, 5)
      .join("");
  updateTime(dynamic val) {
    _time = formatTime(val);
  }

  updateAmount(dynamic val) {
    _amount = val;
  }

  @override
  void initState() {
    _oldTime = widget.time;
    _time = widget.time;
    _amount = widget.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10),
      content: Container(
        height: 180,
        width: screenWidth * 0.9,
        child: Column(
          children: [
            ReusableReminderInputCard(
                type: 'time',
                onInputChange: (dynamic val) => updateTime(val),
                time: _time),
            ReusableReminderInputCard(
              type: 'amount',
              onInputChange: (dynamic val) => updateAmount(val),
              amount: _amount,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();

                      _db.deleteReminder(_time);
                    },
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                        color: buttonRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        child: Center(
                          child: Text(
                            "Delete",
                            style: popupButtonTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _db.updateReminder(_oldTime, _time, _amount);
                    },
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                        color: buttonBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        child: Center(
                          child: Text(
                            "Update",
                            style: popupButtonTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
