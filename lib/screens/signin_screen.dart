import 'package:fil/screens/signup_screen.dart';
import 'package:fil/services/auth.dart';
import 'package:fil/services/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailInputController;
  TextEditingController _passwordInputController;
  bool isError;
  bool isLoading;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    isError = false;
    _emailInputController = TextEditingController();
    _passwordInputController = TextEditingController();
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    _emailInputController.dispose();
    _passwordInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Color(0xFFF9FBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 60),
                child: SvgPicture.asset("images/logo.svg"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 20),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: TextFormField(
                          validator: (val) => validateEmail(val),
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: "Enter your Email",
                          ),
                          controller: _emailInputController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          validator: (val) => validatePassword(val),
                             enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Enter your Password",
                          ),
                          controller: _passwordInputController,
                        ),
                      ),
                      isError
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Login credentials are incorrect',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 62,
                          width: 180,
                          child: CupertinoButton(
                              color: Colors.blueAccent,
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : Text("Sign In"),
                              onPressed: () async {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                                await _auth
                                    .signIn(_emailInputController.text,
                                        _passwordInputController.text)
                                    .then((dynamic value) {
                                  User user = value;
                                  setState(() {
                                    isLoading = !isLoading;
                                    if (user == null) {
                                      print("Error signing in");
                                      isError = true;
                                    } else {
                                      print(
                                          'User uid from email & pass sign in is ${user.uid}');
                                      isError = false;
                                    }
                                  });
                                });
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => Signup()))
                                  .then((_) {
                                _emailInputController.clear();
                                _passwordInputController.clear();
                              });
                            },
                            child: Text(
                              "Don't have an account? Sign Up.",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
