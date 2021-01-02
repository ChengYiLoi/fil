import 'package:fil/constants.dart';
import 'package:fil/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fil/components/components.dart';

class Reminders extends StatefulWidget {
  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  bool isMetric = true;
  DatabaseService _db = DatabaseService();
  String _time = "08:00";
  String _amount;

  isAm(String time) {
    int hours = int.parse(time.split(":").sublist(0, 1).join(""));
    if (hours == 24) {
      return true;
    } else if (hours >= 12) {
      return false;
    }
    return true;
  }

  formatTime(Duration time) => time
      .toString()
      .split('.')
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

  bubbleSort(List reminders) {
    bool isSorted = false;
    while (!isSorted) {
      isSorted = true;
      for (var x = 0; x < reminders.length - 1; x++) {
        var time1 = int.parse(reminders[x].getTime().split(":").first);
        var time2 = int.parse(reminders[x + 1].getTime().split(":").first);
        if (time1 > time2) {
          var temp = reminders[x];
          reminders[x] = reminders[x + 1];
          reminders[x + 1] = temp;
          isSorted = false;
        }
      }
    }
    return reminders;
  }

  Widget _addReminderDialog(context, double screenWidth) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          content: Container(
            height: 180,
            width: screenWidth * 0.9,
            child: Column(
              children: [
                ReusableReminderInputCard(
                    type: "time",
                    onInputChange: (dynamic val) => updateTime(val)),
                ReusableReminderInputCard(
                    type: "amount",
                    onInputChange: (dynamic val) => updateAmount(val)),
                GestureDetector(
                  onTap: () {
                    _db.addReminder(_time, _amount);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Text(
                          "Add Reminder",
                          style: popupButtonTextStyle,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: _db.queryReminders("BJSgTu0rpAfgZuywxpAwZq2GhX72"),
        builder: (context, snapshot) {
          List<ReusableReminderCard> _reminders = [];
          if (snapshot.hasData) {
          
            Map<String, dynamic> remindersObj = snapshot.data;
            remindersObj.forEach((time, obj) {
              _reminders.add(ReusableReminderCard(
                time: time,
                amount: obj['amount'],
                isAm: isAm(time),
                isAlarm: obj['isAlarm'],
              ));
            });
         
            _reminders = bubbleSort(_reminders);
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            StatefulBuilder(
                              builder: (context, setState) {
                                return CupertinoSwitch(
                                    value: isMetric,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isMetric = !isMetric;
                                      });
                                    });
                              },
                            ),
                            Text("${isMetric ? 'Metric' : 'Imperial'}")
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _reminders,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            backgroundColor: Color(0xff88BDBC),
                            onPressed: () {
                              return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return _addReminderDialog(
                                        context, screenWidth);
                                  });
                            },
                            child: Icon(Icons.add),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          );
        });
  }
}
