import 'package:firebase_core/firebase_core.dart';
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

Future<String> initNotifications() async {
  await Firebase.initializeApp();

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) => notificationQueue.put(message),
  );
  return (await FirebaseMessaging.instance.getToken())!;
}
