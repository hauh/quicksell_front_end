import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quicksell_app/profile/lib.dart' show User;

class NotificationQueue with ChangeNotifier {
  List<RemoteMessage> queue = [];

  void put(RemoteMessage message) {
    queue.add(message);
    notifyListeners();
  }

  void pop(RemoteMessage message) {}
}

class AppState with ChangeNotifier {
  static final Function datetimeFormat = DateFormat("dd.MM.yyyy HH:mm").format;
  static final Function currencyFormat = NumberFormat.currency(
    locale: 'ru_RU',
    symbol: '₽',
    decimalDigits: 0,
  ).format;

  bool authenticated = false;
  User? user;
  late String? fcmId;
  late NotificationQueue notificationQueue;

  AppState() : authenticated = false;

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

  Future<void> initNotifications() async {
    notificationQueue = NotificationQueue();

    await Firebase.initializeApp();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) => notificationQueue.put(message),
    );
    fcmId = await FirebaseMessaging.instance.getToken();
  }
}
