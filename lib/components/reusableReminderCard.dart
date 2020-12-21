import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableReminderCard extends StatefulWidget {
  const ReusableReminderCard({
    @required this.time,
    @required this.amount,
    @required this.isAm,
    Key key,
  }) : super(key: key);
  final String time;
  final String amount;
  final bool isAm;

  @override
  _ReusableReminderCardState createState() => _ReusableReminderCardState();
}

class _ReusableReminderCardState extends State<ReusableReminderCard> {
  formatTime(String time) {
    int hours = int.parse(time.split(":").sublist(0, 1).join(""));
    String minutes = time.split(":").sublist(1).join("");
    if (hours >= 13) {
      if(hours <= 21){
        return "0${hours - 12}:$minutes";
      }
      return "${hours - 12}:$minutes";
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    bool isOn = false;
    return Container(
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
                Text(
                  "Amount: ${widget.amount}",
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return CupertinoSwitch(
                    value: isOn,
                    onChanged: (bool value) {
                      setState(() {
                        isOn = !isOn;
                      });
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
