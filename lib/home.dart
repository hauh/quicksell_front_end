import 'package:flutter/material.dart';
import 'package:quicksell_app/extensions.dart';
import 'package:quicksell_app/feed.dart' show Feed;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => context.geo.showMap(context),
          ),
        ],
      ),
      body: Feed(),
    );
  }
}
