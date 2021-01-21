import 'package:flutter/material.dart';
import 'package:quicksell_app/models.dart';
import 'package:quicksell_app/utils.dart' as utils;

class ListingCard extends StatelessWidget {
  final Listing listing;
  ListingCard(this.listing);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.no_photography),
        title: Text(listing.title),
        subtitle: Text(listing.category),
        trailing: Text(utils.currency.format(listing.price)),
      ),
    );
  }
}
