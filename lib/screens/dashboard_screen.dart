import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fil/components/navbarIcon.dart';
import 'package:fil/screens/screens.dart';
import 'package:fil/services/auth.dart';
import 'package:fil/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fil/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  final UserCredential userInfo;

  Dashboard(this.userInfo);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isMetric = true;
  int _pageIndex = 0;
  Map<String, dynamic> _userObj;

  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
        label: "Dashboard",
        activeIcon: NavbarIcon(
          url: "images/graph.png",
          navBarColor: navBarBlue,
        ),
        icon: NavbarIcon(
          url: "images/graph.png",
          navBarColor: navBarGrey,
        )),
    BottomNavigationBarItem(
        label: "Reminders",
        activeIcon: NavbarIcon(
          url: "images/reminder.png",
          navBarColor: navBarBlue,
        ),
        icon: NavbarIcon(
          url: "images/reminder.png",
          navBarColor: navBarGrey,
        )),
    BottomNavigationBarItem(
        label: "Explore",
        activeIcon: NavbarIcon(
          url: "images/map.png",
          navBarColor: navBarBlue,
        ),
        icon: NavbarIcon(
          url: "images/map.png",
          navBarColor: navBarGrey,
        )),
    BottomNavigationBarItem(
      label: "Recepies",
      activeIcon:
          NavbarIcon(url: "images/recepie.png", navBarColor: navBarBlue),
      icon: NavbarIcon(
        url: "images/recepie.png",
        navBarColor: navBarGrey,
      ),
    ),
    BottomNavigationBarItem(
        label: "Logout",
        icon: Padding(
          padding: navIconPadding,
          child: Image.asset(
            "images/logout.png",
          ),
        )),
  ];

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

  Future getUserData(String uid) async {
    return await _db.queryUserData(uid);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(widget.userInfo.user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _userObj = snapshot.data;
          List<BarChartGroupData> barGroupsArray = [];
          print(_userObj);

          _userObj['dailyIntakes'].forEach((obj) {
            DateTime date = DateTime.parse(obj['dateTime']);
            print(date.weekday);
            barGroupsArray.add(BarChartGroupData(x: date.weekday, barRods: [
              BarChartRodData(
                  y: double.parse(obj['amount']), colors: [Color(0xff2e80ec)])
            ]));
          });

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
                              value: isMetric,
                              onChanged: (bool value) {
                                setState(() {
                                  isMetric = !isMetric;
                                });
                              }),
                          Text("${isMetric ? 'Metric' : 'Imperial'}")
                        ],
                      )
                    ],
                  ),
                  CircularPercentIndicator(
                    radius: 140.0,
                    lineWidth: 15.0,
                    percent: 0.5,
                    center: Text(
                      "",
                      style: TextStyle(fontSize: 30),
                    ),
                    progressColor: Color(0xFF8FC1E3),
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
                                "${_userObj['dailyGoal']}ml",
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
                                "${_userObj['dailyIntake']}ml",
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
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    child: CupertinoButton(
                        color: Color(0xFFF9B56A),
                        child: Text("Edit Goal"),
                        onPressed: () {}),
                  ),
                  AspectRatio(
                    aspectRatio: 1.7,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      color: const Color(0xfff6F6F6),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: BarChart(
                          BarChartData(
                              alignment: BarChartAlignment.spaceEvenly,
                              maxY: 6,
                              axisTitleData: FlAxisTitleData(
                                show: true,
                                leftTitle: AxisTitle(
                                    showTitle: true,
                                    titleText: "Litres",
                                    textAlign: TextAlign.end,
                                    margin: 0),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                checkToShowHorizontalLine: (value) {
                                  if (value == 3) {
                                    return true;
                                  }
                                  return false;
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  getTextStyles: (value) => TextStyle(
                                    color: value == 3
                                        ? Colors.black
                                        : Color(0xffD5D5D5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  margin: 20,
                                  getTitles: (double value) {
                                    switch (value.toInt()) {
                                      case 1:
                                        return "Mon";
                                      case 2:
                                        return "Tue";
                                      case 3:
                                        return "Wed";
                                      case 4:
                                        return "Thu";
                                      case 5:
                                        return "Fri";
                                      case 6:
                                        return "Sat";
                                      case 7:
                                        return "Sun";
                                      default:
                                        return '';
                                    }
                                  },
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                ),
                              ),
                              borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    left: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.black),
                                  )),
                              barGroups: barGroupsArray),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoButton(
                        borderRadius: BorderRadius.circular(50.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Image.asset("images/cup.png"),
                        color: Color(0xff88BDBC),
                        onPressed: () {}),
                  )
                ],
              ),
            )),
            bottomNavigationBar: CupertinoTabBar(
              onTap: (val) {
                if (val == 4) {
                  _auth.singOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                } else {
                  setState(() {
                    _pageIndex = val;
                  });
                }
              },
              items: navBarItems,
              currentIndex: _pageIndex,
              activeColor: Colors.black,
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class Sales {
  final String year;
  final int sales;
  Sales(this.year, this.sales);
}
