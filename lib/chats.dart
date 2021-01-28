import 'package:flutter/material.dart';
import 'package:quicksell_app/authorization.dart' show AuthenticationRequired;

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationRequired(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Chats'),
        ),
      ),
    );
  }
}
