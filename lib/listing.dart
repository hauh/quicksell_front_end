import 'package:flutter/material.dart';
import 'package:quicksell_app/models.dart';
import 'package:quicksell_app/utils.dart' as utils;
import 'package:url_launcher/url_launcher.dart' show launch;

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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListingView(listing)),
        ),
      ),
    );
  }
}

class ListingView extends StatelessWidget {
  final Listing listing;
  ListingView(this.listing);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing.title),
        centerTitle: true,
        actions: [
          _ShareButton(),
          _AddToFavoritesButton(),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5.0),
        child: ListView(
          children: [
            _Gallery(listing.photos),
            Divider(color: Colors.black),
            _Price(listing.price),
            _Contact(listing.seller),
            Divider(color: Colors.black),
            _Location(listing.location),
            Divider(color: Colors.black),
            _Description(listing.description),
            Divider(color: Colors.black),
            _Details(listing),
            Divider(color: Colors.black),
            _Stats(listing.views, 123),
            Divider(color: Colors.black),
            _Seller(listing.seller),
          ],
        ), // Bordered(),
      ),
    );
  }
}

abstract class _TopRightButton extends StatelessWidget {
  Icon get icon;
  Text get title;
  Text get message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: this.icon,
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: this.title,
          content: this.message,
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareButton extends _TopRightButton {
  final Icon icon = Icon(Icons.share);
  final Text title = Text('Share');
  final Text message = Text("Share this item?");
}

class _AddToFavoritesButton extends _TopRightButton {
  final Icon icon = Icon(Icons.favorite);
  final Text title = Text('Favorites');
  final Text message = Text("Save this item to favorites?");
}

class _Gallery extends StatelessWidget {
  final photos;
  _Gallery(this.photos);

  @override
  Widget build(BuildContext context) =>
      Image(image: AssetImage('assets/no_image.png'));
}

class _Price extends StatelessWidget {
  final price;
  _Price(this.price);

  @override
  Widget build(BuildContext context) {
    return Text(
      utils.currency.format(this.price),
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}

class _Contact extends StatelessWidget {
  final Seller seller;
  _Contact(this.seller);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _CallButton("1234567890"),
            _ChatButton(),
          ],
        ),
        Text('Online status: ${seller.online}'),
      ],
    );
  }
}

abstract class _ContactButton extends StatelessWidget {
  Text get text;

  @override
  FlatButton build(BuildContext context) {
    return FlatButton(
      onPressed: this.callback,
      child: this.text,
      color: Theme.of(context).backgroundColor,
    );
  }

  void callback();
}

class _CallButton extends _ContactButton {
  final Text text = Text('Call');
  final String phoneNumber;
  _CallButton(this.phoneNumber);

  @override
  void callback() => launch("tel:$phoneNumber");
}

class _ChatButton extends _ContactButton {
  final Text text = Text('Chat');

  @override
  void callback() => null;
}

class _Description extends StatelessWidget {
  final String description;
  _Description(this.description);

  @override
  Widget build(BuildContext context) =>
      Text(this.description.isEmpty ? "Lorem ipsum." : this.description);
}

class _Location extends StatelessWidget {
  final int location;
  _Location(this.location);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.pin_drop, size: 40),
      title: Text("City, metro station."),
      subtitle: Text("Distance from you."),
    );
  }
}

class _Details extends StatelessWidget {
  final Listing listing;
  _Details(this.listing);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Category: ${listing.category}"),
        Text("Condition: ${listing.conditionNew ? "new" : "used"}"),
        Text("Details: ${listing.characteristics}"),
        Text("Date created: ${utils.datetime.format(listing.dateCreated)}"),
        Text("Date expires: ${utils.datetime.format(listing.dateExpires)}"),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  final int views;
  final int favorites;
  _Stats(this.views, this.favorites);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Views: $views"),
        Text("Favorites: $favorites"),
      ],
    );
  }
}

class _Seller extends StatelessWidget {
  final Seller seller;
  _Seller(this.seller);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person, size: 40),
      title: Text(seller.fullName),
      subtitle: Text("Rating: ${seller.rating}"),
    );
  }
}
