import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quicksell_app/feed.dart' show SearchFilters;
import 'package:quicksell_app/profile/lib.dart' show User;

class AppState with ChangeNotifier {
  static final Function datetimeFormat = DateFormat("dd.MM.yyyy HH:mm").format;
  static final Function currencyFormat = NumberFormat.currency(
    locale: 'ru_RU',
    symbol: '₽',
    decimalDigits: 0,
  ).format;

  bool authenticated = false;
  User? user;
  SearchFilters? searchFilters;

  AppState();

  Function get currency => AppState.currencyFormat;
  Function get datetime => AppState.datetimeFormat;

  void logIn(User user) {
    authenticated = true;
    this.user = user;
    notifyListeners();
  }

  void logOut() {
    authenticated = false;
    user = null;
    notifyListeners();
  }
}
