import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prosto_chat/widgets/quicksell_title.dart';
import 'package:prosto_chat/widgets/quicksell_entry_field.dart';
import 'package:prosto_chat/widgets/quicksell_button.dart';
import 'package:prosto_chat/widgets/quicksell_back_button.dart';

import 'package:prosto_chat/screens/authorization/login.dart';

class LoginReferenceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 10,),
            Text(
              'LOGIN',
              style: TextStyle(
                color: Colors.lightBlue[800], fontSize: 13, fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _error;

  @override
  void initState() {
    emailController.addListener(() => setState(() =>_error = null));
    passwordController.addListener(() => setState(() =>_error = null));
    super.initState();
  }

  void onSignup() => _onSignup().then((value) => null);

  Future _onSignup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text
      );
      await FirebaseAuth.instance.currentUser.updateProfile(
        displayName: nameController.text
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "weak-password":
          setState(() => _error = "The password provided is too weak.");
          break;
        case "email-already-in-use":
          setState(() => _error = "The account already exists for that email.");
          break;
        default:
          setState(() => _error = "An undefined Error happened.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
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
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    QuicksellTitle(),
                    SizedBox(height: 50,),
                    Column(
                      children: <Widget>[
                        QuicksellEntryField(
                          inputController: nameController,
                          isPassword: false,
                          title: "Name",
                        ),
                        QuicksellEntryField(
                          inputController: emailController,
                          isPassword: false,
                          title: "Email",
                        ),
                        QuicksellEntryField(
                          inputController: passwordController,
                          isPassword: true,
                          title: "Password",
                        ),
                      ],
                    ),
                    _error != null
                        ? Text(_error, style: TextStyle(color: Colors.red[900]),)
                        : SizedBox(height:0.1),
                    SizedBox(height: 20,),
                    QuicksellButton(
                      title: "SignUp",
                      onTap: onSignup,
                      transparent: false,
                    ),
                    SizedBox(height: height * .14),
                    LoginReferenceButton(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: QuicksellBackButton()),
          ],
        ),
      ),
    );
  }
}