import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ReusableReminderInputCard extends StatefulWidget {
  const ReusableReminderInputCard({
    @required this.type,
    @required this.onInputChange,
    this.time,
    this.amount,
    Key key,
  }) : super(key: key);
  final String type;
  final Function(dynamic) onInputChange;
  final String time;
  final String amount;

  @override
  _ReusableReminderInputCardState createState() =>
      _ReusableReminderInputCardState();
}

class _ReusableReminderInputCardState extends State<ReusableReminderInputCard> {
  String _amount = "";
  Duration _time;
  formatTime(Duration time) => time
      .toString()
      .split('.')
      .first
      .padLeft(8, "0")
      .split("")
      .sublist(0, 5)
      .join("");

  buildTimePicker(setState) {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      onTimerDurationChanged: (Duration value) {
        setState(() {
        
          _time = value;
          widget.onInputChange(value);
        });
      },
      initialTimerDuration: _time,
    );
  }

  buildNumField(setState) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        setState(() {
          _amount = value;
          widget.onInputChange(value);
        });
      },
    );
  }

  convertTime(String time) {
    int hours = int.parse(time.split(":").first);
    int minutes = int.parse(time.split(":").last);

    return Duration(hours: hours, minutes: minutes);
  }

  @override
  void initState() {
    super.initState();
    _time = widget.time == null
        ? Duration(hours: 8, minutes: 0)
        : convertTime(widget.time);
    _amount = widget.amount == null ? "" : widget.amount;
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
                      height: 0.2 * screenHeight,
                      child: buildTimePicker(setState));
                })
            : null;
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
                            widget.onInputChange(value);
                          });
                        },
                        initialValue: _amount,
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
