import 'package:fil/components/navbarIcon.dart';
import 'package:fil/screens/screens.dart';
import 'package:fil/services/auth.dart';
import 'package:fil/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class Navigations extends StatefulWidget {
  final String uid;
  Navigations({this.uid});
  @override
  _NavigationsState createState() => _NavigationsState();
}

class _NavigationsState extends State<Navigations> {
  AuthService _auth = AuthService();
  int _pageIndex = 0;
  List<dynamic> _screens;

  updateTab(int selectedIndex) {
    if (selectedIndex != 4) {
      setState(() {
        _pageIndex = selectedIndex;
      });
    } else {
      _auth.singOut();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
        label: "Dashboard",
        activeIcon: Padding(
          padding: navIconPadding,
          child: SvgPicture.asset(
            "images/graph.svg",
            color: navBarBlue,
          ),
        ),
        icon: Padding(
          padding: navIconPadding,
          child: SvgPicture.asset(
            "images/graph.svg",
            color: navBarGrey,
          ),
        )),
    BottomNavigationBarItem(
        label: "Reminders",
        activeIcon: Padding(
          padding: navIconPadding,
          child: SvgPicture.asset(
            "images/reminder.svg",
            color: navBarBlue,
          ),
        ),
        icon: Padding(
          padding: navIconPadding,
          child: SvgPicture.asset(
             "images/reminder.svg",
            color: navBarGrey,
          ),
        )),
    BottomNavigationBarItem(
        label: "Map",
        activeIcon: Padding(
          padding: navIconPadding,
          child: SvgPicture.asset(
            "images/map.svg",
            color: navBarBlue,
          ),
        ),
        icon: Padding(
          padding: navIconPadding,
          child:  SvgPicture.asset(
            "images/map.svg",
            color: navBarGrey,
          ),
        )),
    BottomNavigationBarItem(
      label: "Recepies",
      activeIcon: Padding(
        padding: navIconPadding,
        child: SvgPicture.asset( "images/recipe.svg", color: navBarBlue),
      ),
      icon: Padding(
        padding: navIconPadding,
        child: SvgPicture.asset(
          "images/recipe.svg",
          color: navBarGrey,
        ),
      ),
    ),
    BottomNavigationBarItem(
      label: "Logout",
      icon: Padding(
        padding: navIconPadding,
        child: SvgPicture.asset('images/logout.svg')
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      Dashboard(),
      Reminders(),
      MapScreen(),
      RecipesScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: ChangeNotifierProvider(
          create: (_) => DatabaseService(uid: widget.uid),
                  child: _screens[_pageIndex],
        ),
      ),
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
