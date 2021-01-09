import 'package:fil/components/components.dart';
import 'package:fil/models/user.dart';
import 'package:fil/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fil/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime current = new DateTime.now();
  String getMonth(obj) {
    List months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[obj.month - 1].toString();
  }

  String dailyRemainder(UserObj user) {
    int dailyGoal = int.parse(user.dailyGoal);
    int dailyIntake = int.parse(user.getDailyIntake());
    int remainder;
    if (dailyGoal >= dailyIntake) {
      remainder = dailyGoal - dailyIntake;
      return remainder.toString();
    }
    return "0";
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final DatabaseService _db =
        Provider.of<DatabaseService>(context, listen: false);
    final double conversion = 29.574;
    return StreamBuilder(
      // widget.userInfo.user.uid
      stream: _db.queryUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserObj _userObj = snapshot.data;
          final DateFormat formatter = DateFormat("yyyy-MM-dd");
          String now = formatter.format(DateTime.now());
          if (!_userObj.dailyIntake.containsKey(now)) {
            print('current date does not have entry');
            _db.createNewEntry(now);
          }

          return Scaffold(
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today, ${current.day} ${getMonth(current)}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Column(
                        children: [
                          CupertinoSwitch(
                              value: _userObj.isMetric,
                              onChanged: (bool value) {
                                setState(() {
                                  _db.updateMeasurement(value);
                                });
                              }),
                          Text("${_userObj.isMetric ? 'Metric' : 'Imperial'}")
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: CircularPercentIndicator(
                      animation: true,
                      radius: 260.0,
                      lineWidth: 26.0,
                      percent: _userObj.getRemainder(),
                      center: Text(
                        "${(_userObj.getRemainder() * 100).round().toString()}%",
                        style: TextStyle(fontSize: 30),
                      ),
                      progressColor: Color(0xFF8FC1E3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Goal",
                                style: progressFontStyle,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "${(int.parse(_userObj.dailyGoal) / (_userObj.isMetric ? 1 : conversion)).round()} ${_userObj.isMetric ? "ml" : "oz"}",
                                style: progressFontStyle.copyWith(
                                    color: progressBlue),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 27.0, right: 27.0),
                          child: SizedBox(
                            width: 6,
                            height: 74,
                            child: Container(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Left",
                                style: progressFontStyle,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "${(int.parse(dailyRemainder(_userObj)) / (_userObj.isMetric ? 1 : conversion)).round()} ${_userObj.isMetric ? "ml" : "oz"}",
                                style: progressFontStyle.copyWith(
                                    color: progressBlue),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: CupertinoButton(
                        color: buttonOrange,
                        child: Text(
                          "Edit Goal",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return ChangeNotifierProvider.value(
                                  value: _db,
                                  child: ReusableAlertBox(
                                    type: "edit",
                                    isMetric: _userObj.isMetric,
                                  ),
                                );
                              });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: CupertinoButton(
                        borderRadius: BorderRadius.circular(50.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: SvgPicture.asset("images/cup.svg"),
                        color: Color(0xff88BDBC),
                        onPressed: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return ChangeNotifierProvider.value(
                                    value: _db,
                                    child: ReusableAlertBox(type: "update", isMetric: _userObj.isMetric,));
                              });
                        }),
                  )
                ],
              ),
            )),
          );
        } else {
          return Scaffold(
            body: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
