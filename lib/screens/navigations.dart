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

  updateTab(int selectedIndex) {
    setState(() {
      _pageIndex = selectedIndex;
    });
  }

  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
        label: "Dashboard",
        activeIcon: Padding(
          padding: navIconPadding,
          child: NavbarIcon(
            url: "images/graph.png",
            navBarColor: navBarBlue,
          ),
        ),
        icon: Padding(
          padding: navIconPadding,
          child: NavbarIcon(
            url: "images/graph.png",
            navBarColor: navBarGrey,
          ),
        )),
    BottomNavigationBarItem(
        label: "Reminders",
        activeIcon: Padding(
          padding: navIconPadding,
          child: NavbarIcon(
            url: "images/reminder.png",
            navBarColor: navBarBlue,
          ),
        ),
        icon: Padding(
          padding: navIconPadding,
          child: NavbarIcon(
            url: "images/reminder.png",
            navBarColor: navBarGrey,
          ),
        )),
    BottomNavigationBarItem(
        label: "Map",
        activeIcon: Padding(
          padding: navIconPadding,
          child: NavbarIcon(
            url: "images/map.png",
            navBarColor: navBarBlue,
          ),
        ),
        icon: Padding(
          padding: navIconPadding,
          child: NavbarIcon(
            url: "images/map.png",
            navBarColor: navBarGrey,
          ),
        )),
    BottomNavigationBarItem(
      label: "Recepies",
      activeIcon: Padding(
        padding: navIconPadding,
        child: NavbarIcon(url: "images/recepie.png", navBarColor: navBarBlue),
      ),
      icon: Padding(
        padding: navIconPadding,
        child: NavbarIcon(
          url: "images/recepie.png",
          navBarColor: navBarGrey,
        ),
      ),
    ),
    BottomNavigationBarItem(
      label: "Logout",
      icon: Padding(
        padding: navIconPadding,
        child: NavbarIcon(
          url: "images/logout.png",
        ),
      ),
    ),
  ];
  List<Widget> _screens = [Dashboard(), Reminders(), MapScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _screens[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedFontSize: 10,
        selectedFontSize: 10,
        currentIndex: _pageIndex,
        onTap: updateTab,
        items: navBarItems,
      ),
    );
  }
}
