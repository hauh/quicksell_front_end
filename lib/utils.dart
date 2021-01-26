import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var currency = NumberFormat.currency(
  locale: 'ru_RU',
  symbol: '₽',
  decimalDigits: 0,
);
var datetime = DateFormat("dd.MM.yyyy HH:mm");

void loadingScreen(BuildContext context, String title) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20.0),
          Text(title),
        ],
      ),
    ),
  );
}

class Notification extends SnackBar {
  Notification(message)
      : super(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        );
}
