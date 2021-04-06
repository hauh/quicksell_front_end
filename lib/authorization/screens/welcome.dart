import 'package:flutter/material.dart';

import 'package:quicksell_app/authorization/widgets/quicksell_title.dart';
import 'package:quicksell_app/authorization/widgets/quicksell_button.dart';

import 'package:quicksell_app/authorization/screens/login.dart';
import 'package:quicksell_app/authorization/screens/signup.dart';

class Authorization extends StatelessWidget {
  Widget child;

  Authorization({this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[50], Colors.blue[900]]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QuicksellTitle(), SizedBox(height: 80,),
            QuicksellButton(
              title: "Login",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              transparent: false,
            ), SizedBox(height: 20,),
            QuicksellButton(
              title: "Register now",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupPage()));
              },
              transparent: true,
            ), SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}