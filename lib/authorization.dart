import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:quicksell_app/extensions.dart';
import 'package:quicksell_app/state.dart' show AppState;

class AuthenticationRequired extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  AuthenticationRequired({required this.builder});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, userState, child) =>
          userState.authenticated ? builder(context) : _Authorization(),
    );
  }
}

class _AuthorizationViewLayout extends StatelessWidget {
  final title;
  final children;
  _AuthorizationViewLayout({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _Authorization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AuthorizationViewLayout(
      title: "Authorization required",
      children: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => _SignInView()),
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
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => _SignUpView()),
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

class _SignInState extends State<_SignInView> {
  final title = "Authorization";
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: _AuthorizationViewLayout(
        title: title,
        children: [
          _EmailField(emailController),
          _SignInPasswordField(passwordController),
          Divider(height: 40),
          ElevatedButton(
            onPressed: () => submitForm(),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void submitForm() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      context.waiting("Authorizing...");
      context.api
          .authenticate(emailController.text, passwordController.text)
          .whenComplete(() => context.stopWaiting())
          .then(
        (user) {
          context.appState.logIn(user);
          context.notify("Welcome back, ${user.profile.name}!");
          Navigator.of(context).pop();
        },
      ).catchError((err) => context.notify(err.toString()));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class _SignUpView extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<_SignUpView> {
  final title = "Registration";
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: _AuthorizationViewLayout(
        title: title,
        children: [
          _NameField(nameController),
          _EmailField(emailController),
          _PhoneField(phoneController),
          _SignUpPasswordField(passwordController),
          _ConfirmPasswordField(passwordController),
          Divider(height: 40),
          ElevatedButton(
            onPressed: () => submitForm(),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void submitForm() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      context.waiting("Creating account...");
      context.api
          .createAccount(
            nameController.text,
            emailController.text,
            "7" + phoneController.text,
            passwordController.text,
            context.notifications.fcmId,
          )
          .whenComplete(() => context.stopWaiting())
          .then(
        (user) {
          context.appState.logIn(user);
          context.notify("Welcome, ${user.profile.name}!");
          Navigator.of(context).pop();
        },
      ).catchError((err) => context.notify(err.toString()));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class _NameField extends StatelessWidget {
  final TextEditingController controller;
  _NameField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: "Name",
        hintText: "How people should call you?",
      ),
      controller: controller,
      keyboardType: TextInputType.name,
      validator: _Validators.name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ЁёА-я]"))
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  _EmailField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.email),
        labelText: "Email",
        hintText: "name@example.com",
      ),
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: _Validators.email,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  _PhoneField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixText: "+7 ",
        icon: Icon(Icons.phone),
        labelText: "Phone",
        hintText: "Your contact phone number",
      ),
      controller: controller,
      keyboardType: TextInputType.phone,
      validator: _Validators.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class _SignInPasswordField extends StatelessWidget {
  final TextEditingController controller;

  _SignInPasswordField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: "Password",
      ),
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class _SignUpPasswordField extends StatelessWidget {
  final TextEditingController controller;
  _SignUpPasswordField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: "Password",
        hintText: "Enter something secure",
      ),
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: _Validators.password,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  _ConfirmPasswordField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: "Confirm password",
        hintText: "Enter the same again",
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (input) =>
          input != controller.text ? "Passwords don't match" : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class _Validators {
  static String? name(String? input) {
    if (input == null || input.length < 5)
      return "Enter at least five characters";
  }

  static final RegExp _emailRegExp = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@"
      r"(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  static String? email(String? input) {
    if (input == null || input.isEmpty) return "Email required";
    if (!_emailRegExp.hasMatch(input)) return "Invalid format";
  }

  static String? phone(String? input) {
    if (input == null || input.length != 10)
      return "Phone length must be 10 digits";
  }

  static final RegExp _pwdUppercaseRegExp = RegExp(r"(?=.*?[A-Z])");
  static final RegExp _pwdLowercaseRegExp = RegExp(r"(?=.*?[a-z])");
  static final RegExp _pwdDigitRegExp = RegExp(r"(?=.*?[0-9])");
  static final RegExp _pwdSpecialCharRegExp = RegExp(r"(?=.*?[#?!@$%^&*-])");

  static String? password(String? input) {
    if (input == null || input.isEmpty) return "Password required";
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
  }
}
