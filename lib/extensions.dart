import 'package:flutter/material.dart';

extension NotificationSnackBar on BuildContext {
  void notify(String message) {
    print(message);
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 60),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: "X",
          onPressed: () => ScaffoldMessenger.of(this).hideCurrentSnackBar(),
        ),
      ),
    );
  }
}

extension WaitingAlert on BuildContext {
  void waiting(String message) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
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

  void stopWaiting() => Navigator.of(this).pop();
}
