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
  TextEditingController _controller;
  int amount;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = "";
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_controller.text != '' &&
                              int.parse(_controller.text) > 0) {
                            _controller.text = (int.parse(_controller.text) -
                                    (widget.isMetric ? 50 : 1))
                                .toString();
                          }
                        });
                      },
                      child: MinusButton()),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              decoration: TextDecoration.none, fontSize: 16),
                          controller: _controller,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Text("${widget.isMetric ? 'ml' : 'oz'}")
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_controller.text == '') {
                            _controller.text = widget.isMetric ? "50" : "1";
                          } else {
                            _controller.text = (int.parse(_controller.text) +
                                    (widget.isMetric ? 50 : 1))
                                .toString();
                          }
                        });
                      },
                      child: AddButton()),
                )
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: widget.type == "edit"
                    ? EditGoalOptions(
                        amount: _controller.text == ""
                            ? 0
                            : int.parse(_controller.text))
                    : RecordGoalOptions(
                        amount: _controller.text == ""
                            ? 0
                            : int.parse(_controller.text)))
          ],
        ),
      ),
    );
  }
}
