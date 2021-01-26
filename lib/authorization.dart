import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:quicksell_app/utils.dart' as utils;
import 'package:quicksell_app/api.dart' as api;

class Authorization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AuthorizationViewLayout(
      title: "Authorization required",
      children: [
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _SignInView()),
          ),
          child: Text("Sign In"),
        ),
        SignInButton(
          Buttons.Google,
          onPressed: () => null,
        ),
        SignInButton(
          Buttons.FacebookNew,
          onPressed: () => null,
        ),
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _SignUpView()),
          ),
          child: Text("Sign Up"),
        ),
      ],
    );
  }
}

class _SignInView extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignUpView extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

abstract class _AuthState<T> extends State {
  String title;
  GlobalKey<FormState> formKey;
  Map<String, TextEditingController> controllers;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    // controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void submitForm(context);
}

class _SignInState extends _AuthState<_SignInView> {
  final title = "Authorization";
  final controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this.formKey,
      child: _AuthorizationViewLayout(
        title: this.title,
        children: [
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              labelText: "Email",
            ),
            controller: this.controllers['email'],
            keyboardType: TextInputType.emailAddress,
            validator: _Validators.email,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: "Password",
            ),
            controller: this.controllers['password'],
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
          ),
          Divider(height: 40),
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => this.submitForm(context),
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  void submitForm(context) {
    if (formKey.currentState.validate()) {
      utils.loadingScreen(context, "Authorizing...");
      var email = this.controllers['email'].text;
      var password = this.controllers['password'].text;
      api.authorize(email, password).then(
        (success) {
          var navigator = Navigator.of(context);
          navigator.pop();
          var notification;
          if (success) {
            notification = utils.Notification("Welcome back!");
            navigator..pop()..pop();
          } else
            notification = utils.Notification("Check your email and password.");
          Scaffold.of(context).showSnackBar(notification);
        },
      );
    }
  }
}

class _SignUpState extends _AuthState<_SignUpView> {
  final title = "Registration";
  final controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this.formKey,
      child: _AuthorizationViewLayout(
        title: this.title,
        children: [
          TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: "Name",
                hintText: "How people should call you?",
              ),
              controller: this.controllers['name'],
              keyboardType: TextInputType.name,
              validator: (value) => value.isEmpty ? "Enter something" : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onEditingComplete: () => FocusScope.of(context).nextFocus()),
          TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: "Email",
                hintText: "name@example.com",
              ),
              controller: this.controllers['email'],
              keyboardType: TextInputType.emailAddress,
              validator: _Validators.email,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onEditingComplete: () => FocusScope.of(context).nextFocus()),
          TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: "Password",
                hintText: "Enter something secure",
              ),
              controller: this.controllers['password'],
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: _Validators.password,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onEditingComplete: () => FocusScope.of(context).nextFocus()),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: "Confirm password",
              hintText: "Enter the same again",
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            validator: (password) =>
                password != this.controllers['password'].text
                    ? "Passwords don't match"
                    : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
          ),
          Divider(height: 40),
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => this.submitForm(context),
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  void submitForm(context) {
    if (formKey.currentState.validate()) {
      utils.loadingScreen(context, "Creating account...");
      var email = this.controllers['email'].text;
      var password = this.controllers['password'].text;
      api.createAccount(email, password).then(
        (success) {
          var navigator = Navigator.of(context);
          navigator.pop();
          var notification;
          if (success) {
            notification = utils.Notification("Welcome to Quicksell App!");
            navigator..pop()..pop();
          } else
            notification = utils.Notification("Check your email and password.");
          Scaffold.of(context).showSnackBar(notification);
        },
      );
    }
  }
}

class _Validators {
  static RegExp _emailRegExp = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@"
      r"(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  static String email(String input) {
    if (input.isEmpty) return "Email required";
    if (!_emailRegExp.hasMatch(input)) return "Invalid format";
    return null;
  }

  static RegExp _pwdUppercaseRegExp = RegExp(r"(?=.*?[A-Z])");
  static RegExp _pwdLowercaseRegExp = RegExp(r"(?=.*?[a-z])");
  static RegExp _pwdDigitRegExp = RegExp(r"(?=.*?[0-9])");
  static RegExp _pwdSpecialCharRegExp = RegExp(r"(?=.*?[#?!@$%^&*-])");

  static String password(String input) {
    if (input.isEmpty) return "Password required";
    if (input.length < 8)
      return "Password must be at least be 8 characters long";
    if (!_pwdUppercaseRegExp.hasMatch(input))
      return "Password must contain at least one uppercase letter";
    if (!_pwdLowercaseRegExp.hasMatch(input))
      return "Password must contain at least one lowercase letter";
    if (!_pwdDigitRegExp.hasMatch(input))
      return "Password must contain at least one digit";
    if (!_pwdSpecialCharRegExp.hasMatch(input))
      return "Password must contain at least one special character";
    return null;
  }
}

class _AuthorizationViewLayout extends StatelessWidget {
  final title;
  final children;
  _AuthorizationViewLayout({@required this.title, @required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(Icons.login, size: 100.0),
              SizedBox(height: 40.0),
              ...this.children,
            ],
          ),
        ),
      ),
    );
  }
}
