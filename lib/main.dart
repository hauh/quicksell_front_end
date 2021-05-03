import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicksell_app/api.dart' show API;
import 'package:quicksell_app/chat/lib.dart' show Chats;
import 'package:quicksell_app/feed.dart' show Feed;
import 'package:quicksell_app/listing/lib.dart' show EditListing;
import 'package:quicksell_app/map.dart' show initMap;
import 'package:quicksell_app/notifications.dart' show initNotifications;
import 'package:quicksell_app/profile.dart' show Profile;
import 'package:quicksell_app/search.dart' show Search;
import 'package:quicksell_app/state.dart' show AppState;
import 'package:quicksell_app/navigation/lib.dart' show Navigation;

void main() => runApp(QuicksellApp());

class QuicksellApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuicksellAppState();
}

class _QuicksellAppState extends State<QuicksellApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: init(),
      builder: (context, snapshot) => snapshot.hasData
          ? snapshot.data!
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<Widget> init() async {
    var navigation = Navigation();

    await navigation.updateCoordinates();

    var appState = AppState(
      location: await initMap(),
      fcmId: await initNotifications(),
    );

    var api = API();
    if (!await api.init()) return errorScreen("Connection error");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (_) => appState,
        ),
        ChangeNotifierProvider<Navigation>(
          create: (_) => navigation,
        ),
        Provider<API>(
          create: (_) => api,
          dispose: (_, api) => api.dispose(),
        ),
      ],
      child: MaterialApp(
        title: "Quicksell App",
        home: MainWidget(),
        routes: {
          '/feed': (_) => Feed(),
          '/chats': (_) => Chats(),
        },
      ),
    );
  }

  Widget errorScreen(String text, {Widget? button}) {
    return MaterialApp(
      home: Scaffold(
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
