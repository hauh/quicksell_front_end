part of chat;

class ChatSearch extends StatefulWidget {
  @override
  _ChatSearchState createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {
  final TextEditingController _filter = TextEditingController();
  List<Chat> _chats = <Chat>[];
  List<Chat> _match = <Chat>[];
  String _pattern = "";

  @override
  void initState() {
    populateChats();

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _pattern = "";
          _match = _chats;
        });
      } else {
        setState(() {
          _pattern = _filter.text;
        });
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 30,
        ),
        onPressed: () {
          Navigator.pop(
            context,
          );
        },
      ),
      titleSpacing: 3.0,
      title: TextField(
        controller: _filter,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              size: 30,
            ),
            hintText: 'Search...'),
      ),
      centerTitle: true,
    );
  }

  Widget buildBody(BuildContext context) {
    if (_chats == null) {
      return (Center(child: CircularProgressIndicator()));
    }

    List<Chat> tmp = <Chat>[];

    if (_pattern != "") {
      for (var chat in _chats) {
        for (var message in chat.messages) {
          if (message.text.toLowerCase().contains(_pattern.toLowerCase())) {
            tmp.add(chat);
          }
        }
      }
      _match = tmp;
    }

    return ListView.builder(
      itemCount: _chats.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 16),
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
                backgroundImage:
                    NetworkImage("https://source.unsplash.com/random/200x200"),
                maxRadius: 30),
            title: Text(_chats[index].subject),
            trailing: Text(_chats[index].listing.price.toString()),
            subtitle: _chats[index].latestMessage!.read
                ? Text(_chats[index].latestMessage!.text,
                    style: TextStyle(color: Colors.brown[10]))
                : Text(_chats[index].latestMessage!.text,
                    style: TextStyle(color: Colors.brown[10])),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Text("Hello"),
              ),
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
}
