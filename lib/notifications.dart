import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationQueue with ChangeNotifier {
  List<RemoteMessage> queue = [];

  void put(RemoteMessage message) {
    queue.add(message);
    notifyListeners();
  }

  void pop(RemoteMessage message) {}
}

final notificationQueue = NotificationQueue();

void init() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    notificationQueue.put(message);
  });
}
