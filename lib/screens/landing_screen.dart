import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fil/constants.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonProportion = 0.9;
    return Scaffold(
      backgroundColor: Color(0xFFF9FBFF),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 110),
            child: Image.asset("images/logo.png"),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 63.0, 20.0, 0.0),
            child: Text(
              "Staying hydrated has never been easier",
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
            ),
          ),
          SizedBox(
            width: screenWidth * buttonProportion,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0,4),
                )]
              ),
              margin: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 10.0),
              child: CupertinoButton(
                  padding: EdgeInsets.all(10.0),
                  color: lightWhite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/email.png"),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text('Continue with Email', style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),
                  onPressed: () {/** */}),
            ),
          ),
          SizedBox(
            width: screenWidth * buttonProportion,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0,4),
                )]
              ),
              margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
              child: CupertinoButton(
                  padding: EdgeInsets.all(10.0),
                  color: lightWhite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/google.png"),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text('Continue with Google', style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),
                  onPressed: () {/** */}),
            ),
          ),
          Expanded(
            child: Image.asset(
              'images/waves.png',
              alignment: Alignment.bottomCenter,
            ),
          )
        ],
      ),
    );
  }
}
