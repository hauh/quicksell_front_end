import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:intl/intl.dart';
import 'package:quicksell_app/models.dart' show User;

class AppState with ChangeNotifier {
  static final Function datetimeFormat = DateFormat("dd.MM.yyyy HH:mm").format;
  static final Function currencyFormat = NumberFormat.currency(
    locale: 'ru_RU',
    symbol: '₽',
    decimalDigits: 0,
  ).format;

  GeoCoordinates location;
  bool authenticated = false;
  String? fcmId;
  User? user;

  AppState({required this.location, required this.fcmId})
      : authenticated = false;

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
