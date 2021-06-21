import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:quicksell_app/chat/lib.dart';

class Notifications with ChangeNotifier {
  late String fcmId;

  Future<void> init() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    fcmId = (await FirebaseMessaging.instance.getToken())!;
  }

  StreamSubscription<RemoteMessage> subscribeToMessages(
    void Function(String, Message) callback,
  ) {
    return FirebaseMessaging.onMessage
        .where((notification) => notification.data['type'] == 'chat_message')
        .listen(
          (notification) => callback(
            notification.data['chat'],
            Message.fromJson(jsonDecode(notification.data['message'])),
          ),
        );
  }
}
