import 'package:fil/screens/dashboard_screen.dart';
import 'package:fil/services/auth.dart';
import 'package:fil/services/validations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _passwordInput = TextEditingController();

  AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
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
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: TextFormField(
                          autofocus: true,
                          validator: (val) => validateEmail(val),
                          decoration: InputDecoration(
                            labelText: "Enter your Email",
                          ),
                          controller: _emailInput,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          validator: (val) => validatePassword(val),
                          decoration: InputDecoration(
                            labelText: "Enter your Password",
                          ),
                          controller: _passwordInput,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CupertinoButton(
                            color: Colors.blueAccent,
                            child: Text("Sign Up"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                dynamic result = await _auth.signUp(
                                    _emailInput.text, _passwordInput.text);
                                if (result) {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => Dashboard(result)));
                                } else {
                                  return showDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      content:
                                          Text("Email has already been used"),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text("Ok"),
                                          onPressed: () {
                                            Navigator.of(context).pop(context);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }
                              // dynamic result = await _auth.(
                              //     _emailInput.text, _passwordInput.text);
                              // if (result == null) {
                              //   print("Error signing in");
                              // } else {
                              //   print(result);
                              // }
                            }),
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
