import 'package:fil/components/navbarIcon.dart';
import 'package:fil/components/reusableAlertBox.dart';
import 'package:fil/models/user.dart';
import 'package:fil/screens/screens.dart';
import 'package:fil/services/auth.dart';
import 'package:fil/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fil/constants.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Dashboard extends StatefulWidget {
  // final UserCredential userInfo;

  // Dashboard(this.userInfo);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isMetric = true;
  int _pageIndex = 0;

  final AuthService _auth = AuthService();
  // TODO add uid when db is initialzed
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

  String dailyRemainder(UserObj user) {
    int dailyGoal = int.parse(user.daily_goal);
    int dailyIntake = int.parse(user.daily_intake);
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
    return StreamBuilder(
      // widget.userInfo.user.uid
      stream: _db.queryUserData("BJSgTu0rpAfgZuywxpAwZq2GhX72"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserObj _userObj = snapshot.data;
          final DateFormat formatter = DateFormat("yyyy-MM-dd");
          String now = formatter.format(DateTime.now());
          _db.checkCurrentDate(_userObj.userID, now);

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
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: CircularPercentIndicator(
                      animation: true,
                      radius: 260.0,
                      lineWidth: 26.0,
                      percent: _userObj.remainder,
                      center: Text(
                        "${(_userObj.remainder * 100).round().toString()}%",
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
                                "${_userObj.daily_goal} ${isMetric ? "ml" : "oz"}",
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
                                "${dailyRemainder(_userObj)} ${isMetric ? "ml" : "oz"}",
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
                        color: Color(0xFFF9B56A),
                        child: Text(
                          "Edit Goal",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return ReusableAlertBox(
                                  type: "edit",
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
                        child: Image.asset("images/cup.png"),
                        color: Color(0xff88BDBC),
                        onPressed: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return ReusableAlertBox(
                                    type: "update");
                              });
                        }),
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
