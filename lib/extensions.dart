import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicksell_app/api.dart' show API;
import 'package:quicksell_app/state.dart' show AppState;

extension Getters on BuildContext {
  API get api => read<API>();
  AppState get appState => read<AppState>();
}

extension NotificationSnackBar on BuildContext {
  Null notify(String message) {
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
