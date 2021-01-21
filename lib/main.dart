import 'package:flutter/material.dart';
import 'package:quicksell_app/chats.dart';
import 'package:quicksell_app/create.dart';
import 'package:quicksell_app/feed.dart';
import 'package:quicksell_app/profile.dart';
import 'package:quicksell_app/search.dart';

void main() => runApp(QuicksellApp());

class QuicksellApp extends StatelessWidget {
  static const String _title = 'Quicksell App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key key}) : super(key: key);

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

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

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
        onTap: _onItemTapped,
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
