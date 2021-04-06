part of listing;

class ListingCard extends StatefulWidget {
  final Listing listing;
  ListingCard(this.listing);

  @override
  State<StatefulWidget> createState() => _CardState();
}

class _CardState extends State<ListingCard> {
  late Listing listing;

  @override
  void initState() {
    listing = widget.listing;
    listing.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.no_photography),
        title: Text(listing.title),
        subtitle: Text(listing.category),
        trailing: Text(AppState.currencyFormat(listing.price)),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => _ListingView(listing)),
        ),
      ),
    );
  }
}

class _ListingView extends StatefulWidget {
  final Listing listing;
  _ListingView(this.listing);

  @override
  State<StatefulWidget> createState() => _ListingViewState();
}

class _ListingViewState extends State<_ListingView> {
  late Listing listing;

  @override
  void initState() {
    listing = widget.listing;
    listing.addListener(() => setState(() {}));
    super.initState();
  }

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
        padding: EdgeInsets.all(5.0),
        child: ListView(
          children: [
            _Gallery(listing.photos),
            Divider(color: Colors.black),
            _Price(listing.price),
            Divider(color: Colors.black),
            listing.seller == context.read<UserState>().user?.profile
                ? _Edit(listing)
                : _Contact(listing),
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

class _TopRightButton extends StatelessWidget {
  final Icon icon;
  final Text title;
  final Text message;
  final Widget action;
  _TopRightButton({
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: title,
          content: message,
          actions: [
            action,
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TopRightButton(
      icon: Icon(Icons.share),
      title: Text("Share"),
      message: Text("Share this item?"),
      action: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("Share"),
      ),
    );
  }
}

class _AddToFavoritesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TopRightButton(
      icon: Icon(Icons.favorite),
      title: Text("Favorites"),
      message: Text("Save this item to favorites?"),
      action: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("Save"),
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  final photos;
  _Gallery(this.photos);

  @override
  Widget build(BuildContext _) =>
      Image(image: AssetImage('assets/no_image.png'));
}

class _Price extends StatelessWidget {
  final price;
  _Price(this.price);

  @override
  Widget build(BuildContext context) {
    return Text(
      AppState.currencyFormat(price),
      style: Theme.of(context).textTheme.headline5,
      textAlign: TextAlign.center,
    );
  }
}

class _Contact extends StatelessWidget {
  final Listing listing;

  _Contact(this.listing);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => launch("tel: 123456789"),
              child: Text('Call'),
            ),
            ElevatedButton(
              onPressed: () {
                API().createChat(listing.seller.uuid, listing.uuid, "Hello")
                  .then((value) => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ChatRoom(chat: value))
                  )
                );
                Navigator.pushNamed(context, '/chats');
              },
              child: Text('Chat'),
            ),
          ],
        ),
        Text('Online status: ${listing.seller.online}'),
      ],
    );
  }
}

class _Edit extends StatelessWidget {
  final Listing listing;
  _Edit(this.listing);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => EditListing.update(listing)),
        ),
        child: Text('Edit'),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String description;
  _Description(this.description);

  @override
  Widget build(BuildContext context) =>
      Text(description.isEmpty ? "Lorem ipsum." : description);
}

class _Location extends StatelessWidget {
  final int? location;
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
        Text("Date created: ${AppState.datetimeFormat(listing.dateCreated)}"),
        Text("Date expires: ${AppState.datetimeFormat(listing.dateExpires)}"),
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
  final Profile seller;
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
