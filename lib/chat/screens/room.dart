part of chats;

class ChatRoom extends StatefulWidget{
  final String chatUuid;
  final String interlocutorUuid;

  ChatRoom({this.chatUuid, this.interlocutorUuid});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  ScrollController _controller = ScrollController(initialScrollOffset: 10, keepScrollOffset: true);
  final TextEditingController _input = TextEditingController();
  List<Message> _messages;
  Profile _interlocutor;
  String _message;

  var _messagesSubscription;
  var _profileSubscription;
  var _messagesStream;
  var _profileStream;

  @override
  void initState() {
    populateMessagesAndProfile();
    API().startMessagesTimer(widget.chatUuid);
    // API().startProfileTimer(widget.interlocutorUuid);
    _messagesStream = API().messagesStream;
    // _profileStream = API().profileStream;
    _messagesSubscription = _messagesStream.listen((messages) {
      print("Test");
      if (_messages == null || messages == null) {  print("one"); return;}
      if (_messages.length == messages.length) { print("two"); return ; }
      print("After");
      setState(() { _messages = messages; });
    });
    // _profileSubscription = _profileStream.listen((profile) {
    //   if (_interlocutor == null || profile == null) { return; }
    //   if (_interlocutor.online == profile.online) { return ; }
    //   setState(() { _interlocutor = profile; });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_messages == null || _interlocutor == null) {
      return (Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
      bottomNavigationBar: Row(
        children: <Widget>[
          SizedBox(width: 10,),
          Expanded(
            child: TextField(
              controller: _input,
              decoration: InputDecoration(
                  hintText: "Write message...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none
              ),
            ),
          ),
          SizedBox(width: 15,),
          FloatingActionButton(
            onPressed: () {
              API().createMessage(widget.chatUuid, _input.text).then((value) => setState(() => _messages.insert(0, value))); _input.clear();
            },
            child: Icon(Icons.send,color: Colors.white,size: 18,),
            backgroundColor: Colors.blue,
            elevation: 0,
          ),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 2,),
              CircleAvatar(
                backgroundImage: NetworkImage("https://source.unsplash.com/random"),
                maxRadius: 25
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_interlocutor.fullName, style: TextStyle(color: Colors.black, fontSize: 17,),),
                    SizedBox(height: 6,),
                    Text(_interlocutor.online ? "Online" : "Offline", style: TextStyle(color: Colors.black54, fontSize: 13),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      child: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: _messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10,bottom: 10),
            physics: NeverScrollableScrollPhysics(),
            reverse: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (_messages[index].is_yours == false ? Alignment.topLeft : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (_messages[index].is_yours == false ? Colors.grey.shade200 : Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(_messages[index].text, style: TextStyle(fontSize: 15),),
                  ),
                ),
              );
            },
          ),
        ],
      )
    );
  }

  void populateMessagesAndProfile() async {
    List<Message> messages = await API().getChatMessages(widget.chatUuid);
    Profile profile = await API().getProfile(widget.interlocutorUuid);
    setState(() {
      _messages = messages;
      _interlocutor = profile;
    });
  }

  void dispose() {
    _messagesSubscription.cancel();
    // _profileSubscription.cancel();
    API().stopMessagesTimer();
    // API().stopProfileTimer();
    super.dispose();
  }
}