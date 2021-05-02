import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quicksell_app/api.dart' show API;
import 'package:quicksell_app/chat/lib.dart' show Chats;
import 'package:quicksell_app/feed.dart' show Feed;
import 'package:quicksell_app/listing/lib.dart' show EditListing;
import 'package:quicksell_app/map.dart' show initMap;
import 'package:quicksell_app/notifications.dart' show initNotifications;
import 'package:quicksell_app/profile.dart' show Profile;
import 'package:quicksell_app/search.dart' show Search;
import 'package:quicksell_app/state.dart' show UserState;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserState>(
          create: (_) => UserState(),
        ),
        Provider<API>(
          create: (_) => API(),
          dispose: (_, api) => api.dispose(),
        ),
      ],
      child: QuicksellApp(),
    ),
  );
}

class QuicksellApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuicksellAppState();
}

class _QuicksellAppState extends State<QuicksellApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quicksell App",
      home: FutureBuilder<Widget>(
        future: init(),
        builder: (context, snapshot) => snapshot.hasData
            ? snapshot.data!
            : Center(child: CircularProgressIndicator()),
      ),
      routes: {
        '/feed': (_) => Feed(),
        '/chats': (_) => Chats(),
      },
    );
  }

  Future<Widget> init() async {
    var locationPermission = await Permission.location.request();
    if (!locationPermission.isGranted) {
      return errorScreen(
        "Location access required",
        button: ElevatedButton(
          onPressed: openAppSettings,
          child: Text("Open settings"),
        ),
      );
    }

    initMap();

    initNotifications();

    var apiStatus = await context.read<API>().init();
    if (!apiStatus) {
      return errorScreen("Connection error");
    }

    return MainWidget();
  }

  Widget errorScreen(String text, {Widget? button}) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            if (button != null) button,
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () => setState(() {}),
              child: Text("Reload"),
            ),
          ],
        ),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  _CurrentPage createState() => _CurrentPage();
}

class _CurrentPage extends State<MainWidget> {
  static List<Widget> pages = <Widget>[
    Feed(),
    Search(),
    EditListing.create(),
    Chats(),
    Profile(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) => setState(() => _selectedIndex = index),
        backgroundColor: Theme.of(context).accentColor,
        selectedItemColor: Colors.amber[600],
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
