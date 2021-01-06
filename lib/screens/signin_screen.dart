
import 'package:fil/screens/signup_screen.dart';
import 'package:fil/services/auth.dart';
import 'package:fil/services/validations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailInputController;
  TextEditingController _passwordInputController;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();

    _emailInputController = TextEditingController();
    _passwordInputController = TextEditingController();
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
                child: Image.asset("images/logo.png"),
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
                          decoration: InputDecoration(
                            labelText: "Enter your Email",
                          
                          ),
                          autofocus: true,
                          controller: _emailInputController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          validator: (val) => validatePassword(val),
                          decoration: InputDecoration(
                            labelText: "Enter your Password",
                          ),
                          controller: _passwordInputController,
                        ),
                      ),
                      CupertinoButton(
                          color: Colors.blueAccent,
                          child: Text("Sign In"),
                          onPressed: () async {
                            dynamic user = await _auth.signIn(
                                _emailInputController.text,
                                _passwordInputController.text);
                            if (user == null) {
                              print("Error signing in");
                            } else {
                              // TODO add provider <User>
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => Dashboard(user)));
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Signup()));
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
