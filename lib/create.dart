import 'package:flutter/material.dart';
import 'package:quicksell_app/authorization.dart' show AuthenticationRequired;

class CreateListing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationRequired(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Listing'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Create Lisiting'),
        ),
      ),
    );
  }
}
