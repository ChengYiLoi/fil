import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fil/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

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
        label: "Reminders",
        icon: Padding(
          padding: navIconPadding,
          child: Image.asset(
            "images/reminder.png",
            color: navBarGrey,
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
        label: "Recepies",
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
                              color:
                                  value == 3 ? Colors.black : Color(0xffD5D5D5),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            margin: 20,
                            getTitles: (double value) {
                              switch (value.toInt()) {
                                case 0:
                                  return "Mon";
                                case 1:
                                  return "Tue";
                                case 2:
                                  return "Wed";
                                case 3:
                                  return "Thu";
                                case 4:
                                  return "Fri";
                                case 5:
                                  return "Sat";
                                case 6:
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
                              left: BorderSide(width: 1.0, color: Colors.black),
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.black),
                            )),
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [
                            BarChartRodData(y: 1, colors: [Color(0xff2E80EC)])
                          ]),
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(y: 1.5, colors: [Color(0xff2E80EC)])
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(y: 2, colors: [Color(0xff2E80EC)])
                          ]),
                          BarChartGroupData(x: 3, barRods: [
                            BarChartRodData(y: 2.5, colors: [Color(0xff2E80EC)])
                          ]),
                          BarChartGroupData(x: 4, barRods: [
                            BarChartRodData(y: 0, colors: [Color(0xff2E80EC)])
                          ]),
                          BarChartGroupData(x: 5, barRods: [
                            BarChartRodData(y: 0, colors: [Color(0xff2E80EC)])
                          ]),
                          BarChartGroupData(x: 6, barRods: [
                            BarChartRodData(y: 0, colors: [Color(0xff2E80EC)])
                          ]),
                        ]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(50.0),
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Image.asset("images/cup.png"),
                  color: Color(0xff88BDBC),
                  onPressed: () {}),
            )
           
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

class Sales {
  final String year;
  final int sales;
  Sales(this.year, this.sales);
}
