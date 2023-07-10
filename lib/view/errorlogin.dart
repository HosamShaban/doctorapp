import 'package:flutter/material.dart';

class FaildLogin extends StatelessWidget {
  const FaildLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Column(children: <Widget>[
            Center(
              child: Container(
                height: 150,
                width: 150,
                child: Image.asset("assets/images/error.png"),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: Container(
                  child: Text(
                "فشل تسجيل الدخول",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                ),
              )),
            ),
          ])
        ])));
  }
}
