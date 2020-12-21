import 'package:fil/components/navbarIcon.dart';
import 'package:fil/screens/screens.dart';
import 'package:fil/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class Navigations extends StatefulWidget {
  @override
  _NavigationsState createState() => _NavigationsState();
}

class _NavigationsState extends State<Navigations> {
  AuthService _auth = AuthService();
  int _pageIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
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
        tabBuilder: (context, index) {
          if (index == 0) {
            return CupertinoTabView(
              builder: (context) => Dashboard(),
            );
          } else if (index == 1) {
            return CupertinoTabView(
              builder: (context) => Reminders(),
            );
          } else {
            // _auth.singOut();
            Navigator.pop(context);
          }
        });
  }
}
