import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quicksell_app/models.dart' show User;

class AppState {
  static final Function datetimeFormat = DateFormat("dd.MM.yyyy HH:mm").format;
  static final Function currencyFormat = NumberFormat.currency(
    locale: 'ru_RU',
    symbol: '₽',
    decimalDigits: 0,
  ).format;
}

class UserState with ChangeNotifier {
  bool _authenticated = false;
  String? fcm_id;
  User? user;

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
