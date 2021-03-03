import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quicksell_app/models.dart' show User;

class AppState {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  static final Function datetimeFormat = DateFormat("dd.MM.yyyy HH:mm").format;
  static final Function currencyFormat = NumberFormat.currency(
    locale: 'ru_RU',
    symbol: '₽',
    decimalDigits: 0,
  ).format;

  static void notify(String message) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 60),
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
  User user;

  bool get authenticated => _authenticated;

  void logIn(User user) {
    _authenticated = true;
    this.user = user;
    notifyListeners();
  }

  void logOut() {
    _authenticated = false;
    user = null;
    notifyListeners();
  }
}
