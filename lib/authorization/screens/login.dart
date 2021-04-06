import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:prosto_chat/widgets/quicksell_title.dart';
import 'package:prosto_chat/widgets/quicksell_back_button.dart';
import 'package:prosto_chat/widgets/quicksell_entry_field.dart';
import 'package:prosto_chat/widgets/quicksell_button.dart';

import 'package:prosto_chat/screens/authorization/signup.dart';

class LoginPageDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(width: 20,),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(thickness: 1, color: Colors.blue[900],),
            ),
          ),
          Text('OR'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(thickness: 1, color: Colors.blue[900]),
            ),
          ),
          SizedBox(width: 20,),
        ],
      ),
    );
  }
}

class LoginPageGoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)
            ),
            child: Image.asset("assets/google.jpg"),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)
                ),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Google',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignupReferenceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignupPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 7,),
            Text(
              'SignUp',
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

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _error;

  @override
  void initState() {
    emailController.addListener(() => setState(() =>_error = null));
    passwordController.addListener(() => setState(() =>_error = null));
    super.initState();
  }

  void onLogin() => _onLogin().then((value) => null);

  Future _onLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          setState(() => _error = "Your email address appears to be malformed.");
          break;
        case "invalid-password":
          setState(() => _error = "Your password appears to be malformed.");
          break;
        case "user-not-found":
          setState(() => _error = "User with this email doesn't exist.");
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
                color: Colors.grey.shade200, offset: Offset(2, 4),
                blurRadius: 5, spreadRadius: 2
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
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
                    SizedBox(height: 50),
                    Column(
                      children: <Widget>[
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
                    SizedBox(height: 20),
                    QuicksellButton(
                      title: "Login",
                      onTap: onLogin,
                      transparent: false,
                    ),
                    SizedBox(height: 25,),
                    LoginPageDivider(),
                    LoginPageGoogleButton(),
                    SizedBox(height: height * .055),
                    SignupReferenceButton(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: QuicksellBackButton()),
          ],
        ),
      )
    );
  }
}
