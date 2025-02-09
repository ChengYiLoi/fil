import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

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
  TimeOfDay _time;

  formatTime(TimeOfDay time) {
    String hour = time.hour.toString();
    String minute = time.minute.toString();
    if (time.hour <= 9) {
      hour = "0" + time.hour.toString();
    }
    if (time.minute <= 9) {
      minute = "0" + time.minute.toString();
    }
    return (hour + ":" + minute);
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

    return TimeOfDay(hour: hours, minute: minutes);
  }

  @override
  void initState() {
    super.initState();
    _time = widget.time == null ? TimeOfDay.now() : convertTime(widget.time);
    _amount = widget.amount == null ? "" : widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        return widget.type == 'time'
            ? Navigator.of(context).push(showPicker(
                value: _time,
                onChange: (TimeOfDay time) {
                  widget.onInputChange(time);
                  setState(() {
                    _time = time;
                  });
                },
              ))
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
