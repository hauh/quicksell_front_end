import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppState {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static final Function currencyFormat = NumberFormat.currency(
    locale: 'ru_RU',
    symbol: '₽',
    decimalDigits: 0,
  ).format;
  static final Function datetimeFormat = DateFormat("dd.MM.yyyy HH:mm").format;

  static void notify(String message) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 50),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: "X",
          onPressed: () => scaffoldKey.currentState.hideCurrentSnackBar(),
        ),
      ),
    );
  }

  static void waiting(String message) {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20.0),
            Text(message),
          ],
        ),
      ),
    );
  }

  static void stopWaiting() => Navigator.of(navigatorKey.currentContext).pop();
}

class UserState with ChangeNotifier {
  bool _authenticated = false;

  bool get authenticated => _authenticated;
  set authenticated(bool newStatus) {
    _authenticated = newStatus;
    notifyListeners();
  }

  void logIn() => authenticated = true;
  void logOut() => authenticated = false;
}