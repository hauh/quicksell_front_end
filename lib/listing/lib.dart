library listing;

import 'dart:convert' show jsonEncode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:provider/provider.dart';
import 'package:quicksell_app/authorization.dart' show AuthenticationRequired;
import 'package:quicksell_app/chat/lib.dart';
import 'package:quicksell_app/extensions.dart';
import 'package:quicksell_app/models.dart' show Profile;
import 'package:url_launcher/url_launcher.dart' show launch;
import 'package:quicksell_app/navigation/lib.dart';

part 'edit.dart';
part 'model.dart';
part 'view.dart';
