import 'package:fil/components/editReminderAlertBox.dart';
import 'package:fil/main.dart';
import 'package:fil/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class ReusableReminderCard extends StatefulWidget {
  const ReusableReminderCard({
    @required this.time,
    @required this.amount,
    @required this.isAm,
    @required this.isAlarm,
    @required this.isMetric,
    Key key,
  }) : super(key: key);
  final String time;
  final String amount;
  final bool isAm;
  final bool isAlarm;
  final bool isMetric;

  String getTime() {
    return this.time;
  }

  @override
  _ReusableReminderCardState createState() => _ReusableReminderCardState();
}

class _ReusableReminderCardState extends State<ReusableReminderCard> {
  final double conversion = 29.574;
  void setAlarm(String time, String amount, _db) async {
    int hour = int.parse(time.split(":").first);
    int minutes = int.parse(time.split(":").last);
    int id = int.parse(hour.toString() + minutes.toString());
    Time scheduledNotificationTime = Time(hour, minutes, 0);
    _db.updateIsAlarm(time, true);
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Channel Name", "test test",
        importance: Importance.High);
    var iOSDetails = new IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iOSDetails);
    // await flutterLocalNotificationsPlugin.periodicallyShow(0, "title", "body",
    //     RepeatInterval.everyMinute, generalNotificationDetails);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        "Fil Daily Hydration Reminder",
        "It is time to hydrate yourself with ${(int.parse(widget.amount) / (widget.isMetric ? 1 : conversion)).round()} ${widget.isMetric ? "ml" : "oz"} of water!",
        scheduledNotificationTime,
        generalNotificationDetails);
    print("alarm is set, id is $id");
  }

  void cancelAlarm(String time, _db) async {
    int hour = int.parse(time.split(":").first);
    int minutes = int.parse(time.split(":").last);
    int id = int.parse(hour.toString() + minutes.toString());

    await flutterLocalNotificationsPlugin.cancel(id);
    _db.updateIsAlarm(time, false);
    print('alarm cancelled, id is $id');
  }

  formatTime(String time) {
    int hours = int.parse(time.split(":").sublist(0, 1).join(""));
    String minutes = time.split(":").sublist(1).join("");
    if (hours >= 13) {
      if (hours <= 21) {
        return "0${hours - 12}:$minutes";
      }
      return "${hours - 12}:$minutes";
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService _db =
        Provider.of<DatabaseService>(context, listen: false);
    bool isAlarm = widget.isAlarm;
    return GestureDetector(
      // onTap: () => _buildEditAlertBox(widget.time, widget.amount, _db),
      onTap: () {
        return _buildEditAlertBox(context, _db);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Color(0xffEFEFEF), borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${formatTime(widget.time)} ${widget.isAm ? "AM" : "PM"}",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Amount: ${(int.parse(widget.amount) / (widget.isMetric ? 1 : conversion)).round()} ${widget.isMetric ? "ml" : "oz"}",
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  return CupertinoSwitch(
                      value: isAlarm,
                      onChanged: (bool value) {
                        if (value) {
                          print('alaram is set for ${widget.time}');
                          setAlarm(widget.time, widget.amount, _db);
                        } else {
                          cancelAlarm(widget.time, _db);
                        }
                        setState(() {
                          isAlarm = !isAlarm;
                        });
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildEditAlertBox(BuildContext context, DatabaseService _db) {
    return showDialog(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider.value(
              value: _db,
              child: EditReminderAlertBox(
                time: widget.time,
                amount: widget.amount,
              ));
        });
  }
}
