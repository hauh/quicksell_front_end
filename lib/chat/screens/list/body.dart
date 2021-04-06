part of chat;

class ChatListTileImage extends StatelessWidget {
  final String _imageUrl;

  ChatListTileImage({required String imageUrl}) : _imageUrl = imageUrl;

  @override
  Widget build (BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(_imageUrl),
      maxRadius: 30,
    );
  }
}

class ChatListTileTextArea extends StatelessWidget {
  final String _fullName;
  final String _title;
  final String _latestMessage;

  ChatListTileTextArea({
    required String fullName,
    required String title,
    required String latestMesage
  }) : _fullName = fullName, _title = title, _latestMessage = latestMesage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            _fullName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            _title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16)
          ),
        ),
        Expanded(
          child: Text( // TODO: Bold font when read is false
            _latestMessage, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, color: Colors.grey)
          ),
        ),
      ]
    );
  }
}

class ChatListTilePriceArea extends StatelessWidget {
  final String _price;

  ChatListTilePriceArea({required String price}) : _price = price;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(_price));
  }
}

class ChatListTile extends StatelessWidget{
  final Chat _chat;

  ChatListTile({required Chat chat}) : _chat = chat;

  @override
  Widget build(BuildContext context) {
    // TODO: Long pressure to open pop up menu where you can delete message
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatRoom(chat: _chat)),
          );
        },
        child: Container(
          height: 70,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ChatListTileImage(
                  imageUrl: "https://source.unsplash.com/random/200x200"
                )
              ),
              Expanded(
                flex: 3,
                child: ChatListTileTextArea(
                  fullName: _chat.interlocutor.fullName,
                  title: _chat.listing.title,
                  latestMesage: _chat.latestMessage.text,
                ),
              ),
              Expanded(
                child: ChatListTilePriceArea(price: _chat.listing.price.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatListBody extends StatefulWidget {
  @override
  _ChatListBodyState createState() => _ChatListBodyState();
}

class _ChatListBodyState extends State<ChatListBody> {
  ScrollController? _controller;
  var logger = Logger();
  List<Chat>? _chats;
  var listener;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(onScroll);
    listener = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (_chats == null) return; // TODO: queue message to try next time
      logger.d("FCM foreground data:\n${message.data}");
      if (message.notification != null) {
        logger.d("Additional FCM foreground data: ${message.notification}");
      }
      setState(() {}); //TODO: Send message itself in message.data
      //TODO: Insert new data without bothering server
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().getChats(), //TODO: Lazy loading for chats
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _chats = snapshot.data as List<Chat>;
          if (_chats!.isEmpty) {
            return Center(
              child: Text(
                "You do not have any messages yet!",
                style: TextStyle(fontSize: 23, color: Colors.grey),
              )
            );
          }
          return ListView.builder(
            controller: _controller,
            itemCount: _chats!.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 7),
            itemBuilder: (context, index) {
              return ChatListTile(
                chat: _chats![_chats!.length - index - 1]
              );
            }
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void onScroll() => null;

  @override
  void dispose() {
    _controller!.removeListener(onScroll);
    listener.remove();
    super.dispose();
  }
}