import 'package:fil/screens/navigations.dart';
import 'package:fil/screens/signin_screen.dart';
import 'package:fil/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fil/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  AuthService _auth = AuthService();

  isUserLoggedIn() {
    _auth.isUserSignedIn().onData((user) {
      if (user != null) {
        print('user has logged in');
        print('user id is ${user.uid}');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Navigations(
              uid: user.uid,
            ),
          ),
        );
      } else {
        print('user has not signed in');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isUserLoggedIn();
  }

  Future _preCacheImages() async {
    return Future.wait([
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder, 'images/logo.svg'),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder, 'images/email.svg'),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder, 'images/google.svg'),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder, 'images/waves.svg'),
          null),
      Future.delayed(Duration(seconds: 2), () {})
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonProportion = 0.9;
    return FutureBuilder(
      future: _preCacheImages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFFF9FBFF),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 110),
                  child: SvgPicture.asset("images/logo.svg"),
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
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      )
                    ]),
                    margin: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 10.0),
                    child: CupertinoButton(
                        padding: EdgeInsets.all(10.0),
                        color: lightWhite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("images/email.svg"),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(
                                'Continue with Email',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignIn()));
                        }),
                  ),
                ),
                SizedBox(
                  width: screenWidth * buttonProportion,
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      )
                    ]),
                    margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                    child: CupertinoButton(
                        padding: EdgeInsets.all(10.0),
                        color: lightWhite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("images/google.svg"),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(
                                'Continue with Google',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          UserCredential user = await _auth.googleSignin();

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Navigations(
                                    uid: user.user.uid,
                                  )));
                        }),
                  ),
                ),
                Expanded(
                  child: SvgPicture.asset(
                    'images/waves.svg',
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.fitWidth,
                  ),
                )
              ],
            ),
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
