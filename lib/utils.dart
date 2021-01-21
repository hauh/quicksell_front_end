import 'package:intl/intl.dart';

var currency = NumberFormat.currency(
  locale: 'ru_RU',
  symbol: '₽',
  decimalDigits: 0,
);
var datetime = DateFormat("dd.MM.yyyy HH:mm");
