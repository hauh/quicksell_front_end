part of chats;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Chat> _chats;
  var _subscription;
  var _stream;

  @override
  void initState() {
    populateChats();
    API().startChatsTimer();
    _stream = API().chatsStream;
    _subscription = _stream.listen((chats) {
      if (_chats == null || chats == null) { return; }
      if (chats.length != _chats.length) {
        setState(() { _chats = chats; });
        return ;
      }
      for (var i = 0; i < _chats.length && i < 10; ++i) {
        if (_chats[i].latestMessage.text != chats[i].latestMessage.text) {
          setState(() { _chats = chats; });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.remove_circle, size: 30, ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BlackList())
            );
          }
      ),
      titleSpacing: 3.0,
      title: Text("Chats"),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search, size: 30,),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatSearch(),)
              );
            }
        ),
      ]
    );
  }

  Widget buildBody(BuildContext context) {
    if (_chats == null) {
      return (Center(child: CircularProgressIndicator()));
    }
    return ListView.builder(
      itemCount: _chats.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 16),
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
                backgroundImage: NetworkImage("https://source.unsplash.com/random/200x200"),
                maxRadius: 30
            ),
            title: Text(_chats[index].subject),
            trailing: Text(_chats[index].listing.price.toString()),
            subtitle: _chats[index].latestMessage.read
                ? Text(
                _chats[index].latestMessage.text,
                style: TextStyle(color: Colors.black, fontSize: 15, fontStyle: FontStyle.italic)
             )
                : Text(
                _chats[index].latestMessage.text,
                style: TextStyle(fontSize: 13)
             ),
             onTap: () => Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => ChatRoom(
                 chatUuid: _chats[index].uuid,
                 interlocutorUuid: _chats[index].interlocutor.uuid,
               ),),
             ),
           ),
         );
       },
    );
  }

  void populateChats() async {
    List<Chat> chats = await API().getChats();
    setState(() => _chats = chats);
  }

  void dispose() {
    _subscription.cancel();
    API().stopChatsTimer();
    super.dispose();
  }
}