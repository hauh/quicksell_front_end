library listing;

import 'dart:convert' show jsonEncode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:provider/provider.dart';
import 'package:quicksell_app/api.dart' show API;
import 'package:quicksell_app/authorization.dart' show AuthenticationRequired;
import 'package:quicksell_app/models.dart' show Profile;
import 'package:quicksell_app/state.dart' show AppState, UserState;
import 'package:url_launcher/url_launcher.dart' show launch;

part 'edit.dart';
part 'model.dart';
part 'view.dart';
