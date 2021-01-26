import 'package:flutter/material.dart';
import 'package:quicksell_app/api.dart' as api;
import 'package:quicksell_app/chats.dart' show Chats;
import 'package:quicksell_app/create.dart' show CreateListing;
import 'package:quicksell_app/feed.dart' show Feed;
import 'package:quicksell_app/profile.dart' show Profile;
import 'package:quicksell_app/search.dart' show Search;
import 'package:quicksell_app/authorization.dart' show Authorization;
import 'package:quicksell_app/state.dart' show AppState;

void main() => runApp(QuicksellApp());

class QuicksellApp extends StatelessWidget {
  static const String title = 'Quicksell App';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppState.navigatorKey,
      title: title,
      builder: (context, widget) => Scaffold(
        key: AppState.scaffoldKey,
        body: widget,
      ),
      home: FutureBuilder<bool>(
        future: api.connect(),
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data
              ? MainWidget()
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  _CurrentPage createState() => _CurrentPage();
}

class _CurrentPage extends State<MainWidget> {
  int _selectedIndex = 0;
  static List<Widget> pages = <Widget>[
    Feed(),
    Search(),
    CreateListing(),
    Chats(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        selectedItemColor: Colors.amber[600],
        unselectedItemColor: Colors.white,
        onTap: (int index) {
          index == 0
              ? setState(() => _selectedIndex = index)
              : Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Authorization()),
                );
        },
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
