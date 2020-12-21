import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ReusableReminderInputCard extends StatefulWidget {
  const ReusableReminderInputCard({
    @required this.type,
    Key key,
  }) : super(key: key);
  final String type;
  @override
  _ReusableReminderInputCardState createState() =>
      _ReusableReminderInputCardState();
}

class _ReusableReminderInputCardState extends State<ReusableReminderInputCard> {
  Duration _time = Duration(hours: 8, minutes: 0, seconds: 0);
  String _amount = "0";
  formatTime(Duration time) => time.toString().split('.').first.padLeft(8, "0");
  showPicker(setState) {
    return CupertinoTimerPicker(
      onTimerDurationChanged: (Duration value) {
        setState(() {
          _time = value;
        });
      },
      initialTimerDuration: _time,
    );
  }

  showTextField(setState) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        setState(() {
          _amount = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        return widget.type == 'time'
            ? showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                      height: 0.2 * screenHeight, child: showPicker(setState));
                })
            : showTextField(setState);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
              // color: Color(0xffEFEFEF),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.type == 'time' ? 'Time: ' : 'Amount: '}",
                  style: TextStyle(fontSize: 24),
                ),
                widget.type == 'time'
                    ? Text(
                        "${formatTime(_time)}",
                        style: TextStyle(fontSize: 24),
                      )
                    : Expanded(
                        child: TextFormField(
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          setState(() {
                            _amount = value;
                          });
                        },
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
