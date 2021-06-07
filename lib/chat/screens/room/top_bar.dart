part of chat;

class ChatRoomTopBarInterlocutor extends StatefulWidget {
  final Profile _interlocutor;

  ChatRoomTopBarInterlocutor({required Profile interlocutor})
      : _interlocutor = interlocutor;

  @override
  _ChatRoomTopBarInterlocutorState createState() =>
      _ChatRoomTopBarInterlocutorState();
}

class _ChatRoomTopBarInterlocutorState
    extends State<ChatRoomTopBarInterlocutor> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CircleAvatar(
            backgroundImage:
                NetworkImage("https://source.unsplash.com/random/200x200"),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget._interlocutor.name, textAlign: TextAlign.start),
              Text(widget._interlocutor.online ? "Online" : "Offline"),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatRoomTopBarDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: VerticalDivider(
            color: Colors.black, thickness: 1.0, endIndent: 7.0, indent: 7.0));
  }
}

class ChatRoomTopBarListing extends StatelessWidget {
  final Listing _listing;

  ChatRoomTopBarListing({required Listing listing}) : _listing = listing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Center(
                child: Text(_listing.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16)))),
        Expanded(
          child: CircleAvatar(
            backgroundImage:
                NetworkImage("https://source.unsplash.com/random/200x200"),
          ),
        ),
      ],
    );
  }
}

class ChatRoomTopBar extends StatelessWidget {
  final Listing _listing;

  ChatRoomTopBar({required Listing listing}) : _listing = listing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.blue.shade200, Colors.blue.shade500],
        ),
      ),
      child: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
                child: IconButton(
                    icon: Icon(Icons.arrow_back, size: 30),
                    onPressed: () => Navigator.pop(context))),
            Expanded(
                flex: 3,
                child: ChatRoomTopBarInterlocutor(
                  interlocutor: _listing.seller,
                )),
            Expanded(
              child: ChatRoomTopBarDivider(),
            ),
            Expanded(
              flex: 4,
              child: ChatRoomTopBarListing(listing: _listing),
            ),
          ],
        ),
      ),
    );
  }
}
