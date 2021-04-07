import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicksell_app/api.dart' show API;
import 'package:quicksell_app/chat/lib.dart' show Chats;
import 'package:quicksell_app/feed.dart' show Feed;
import 'package:quicksell_app/listing/lib.dart' show EditListing;
import 'package:quicksell_app/profile.dart' show Profile;
import 'package:quicksell_app/search.dart' show Search;
import 'package:quicksell_app/state.dart' show UserState;
import 'package:quicksell_app/notifications.dart' show init;

void main() {
  init();
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

class QuicksellApp extends StatelessWidget {
  static const String title = 'Quicksell App';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: FutureBuilder<bool>(
        future: context.read<API>().init(),
        builder: (context, snapshot) => snapshot.hasData && snapshot.data!
            ? MainWidget()
            : Center(child: CircularProgressIndicator()),
      ),
      routes: {
        '/feed': (_) => Feed(),
        '/chats': (_) => Chats(),
      },
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
