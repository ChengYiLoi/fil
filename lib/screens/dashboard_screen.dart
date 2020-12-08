import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fil/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isMetric = true;

  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
      label: "Dashboard",
        icon: Padding(
          padding: navIconPadding,
          child: Image.asset(
      "images/graph.png",
      color: navBarBlue,
    ),
        )),
    BottomNavigationBarItem(
      label: "Explore",
        icon: Padding(
          padding: navIconPadding,
          child: Image.asset(
      "images/map.png",
      color: navBarGrey,
    ),
        )),
    BottomNavigationBarItem(
      label: "Recepie",
        icon: Padding(
          padding: navIconPadding,
          child: Image.asset(
      "images/recepie.png",
      color: navBarGrey,
    ),
        )),
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

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
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
                "50%",
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
                          "3000ml",
                          style:
                              progressFontStyle.copyWith(color: progressBlue),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 27.0, right: 27.0),
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
                          "750ml",
                          style:
                              progressFontStyle.copyWith(color: progressBlue),
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
            Container(
              height: 240,
              child: SfCartesianChart())
          ],
        ),
      )),
      bottomNavigationBar: CupertinoTabBar(
        items: navBarItems,

        currentIndex: 0,
        activeColor: Colors.black,
      ),
    );
  }
}
