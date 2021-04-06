library chat;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

import 'package:quicksell_app/models.dart';
import 'package:quicksell_app/api.dart';
import 'package:quicksell_app/listing/lib.dart';
import 'package:quicksell_app/authorization.dart';

part 'chat.dart';

part 'screens/list/list.dart';
part 'screens/list/top_bar.dart';
part 'screens/list/body.dart';

part 'screens/room/room.dart';
part 'screens/room/top_bar.dart';
part 'screens/room/body.dart';
part 'screens/room/bottom_bar.dart';

part 'screens/search/search.dart';

part 'screens/black_list/black_list.dart';