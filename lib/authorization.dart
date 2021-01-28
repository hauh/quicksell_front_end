import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:quicksell_app/api.dart' as api;
import 'package:quicksell_app/state.dart' show AppState, UserState;

class AuthenticationRequired extends Consumer<UserState> {
  AuthenticationRequired({@required Widget child})
      : super(
          builder: (BuildContext context, UserState userState, Widget child) =>
              userState.authenticated ? child : _Authorization(),
          child: child,
        );
}

class _Authorization extends StatelessWidget {
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
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void submitForm(BuildContext context);
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
          ElevatedButton(
            onPressed: () => this.submitForm(context),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void submitForm(context) {
    FocusScope.of(context).unfocus();
    if (formKey.currentState.validate()) {
      AppState.waiting("Authorizing...");
      api
          .authorize(
            this.controllers['email'].text,
            this.controllers['password'].text,
          )
          .whenComplete(() => AppState.stopWaiting())
          .then(
        (isSuccess) {
          if (isSuccess) {
            Provider.of<UserState>(context, listen: false).logIn();
            AppState.notify("Welcome back!");
            Navigator.of(context).pop();
          } else
            AppState.notify("Check your email and password");
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
          ElevatedButton(
            onPressed: () => this.submitForm(context),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void submitForm(context) {
    FocusScope.of(context).unfocus();
    if (formKey.currentState.validate()) {
      AppState.waiting("Creating account...");
      api
          .createAccount(
            this.controllers['email'].text,
            this.controllers['password'].text,
          )
          .whenComplete(() => AppState.stopWaiting())
          .then(
        (isSuccess) {
          if (isSuccess) {
            Provider.of<UserState>(context, listen: false).logIn();
            var name = this.controllers['name'].text;
            AppState.notify("Welcome to Quicksell App, $name!");
            Navigator.of(context).pop();
          } else
            AppState.notify("Registration failed");
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
