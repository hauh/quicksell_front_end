part of chat;

class ChatRoomBody extends StatefulWidget {
  final String _chatUuid;

  ChatRoomBody({required String chatUuid}) : _chatUuid = chatUuid;

  @override
  _ChatRoomBodyState createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends State<ChatRoomBody> {
  TextEditingController? _inputController;
  ScrollController? _scrollController;
  List<Message>? _messages;
  var logger = Logger();
  var listener;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _scrollController = ScrollController()..addListener(onScroll);
    print("Hello from init");
    listener = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if (_messages == null) return; // TODO: queue message to try next time
      logger.d("FCM foreground data:\n${message.data}");
      if (message.notification != null) {
        logger.d("Additional FCM foreground data: ${message.notification}");
      }
      setState(() {}); //TODO: Send message itself in message.data
      _scrollController!.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      //TODO: Insert new data without bothering server
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: API().getChatMessages(widget._chatUuid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _messages = snapshot.data as List<Message>;
            if (_messages!.isEmpty) {
              return Center(
                  child: Text(
                    "Empty", style: TextStyle(fontSize: 23, color: Colors.grey),
                  )
              );
            }
            return Scaffold(
              body: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ListView.builder(
                      itemCount: _messages!.length,
                      reverse: true,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment: (_messages![index].is_yours == false
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (_messages![index].is_yours == false
                                    ? Colors.grey.shade200
                                    : Colors.blue[200]),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Text(
                                _messages![index].text,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ),
              bottomNavigationBar: Container(
                child: ChatRoomBottomBar(chatUuid: widget._chatUuid),
              ),
            );
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  void onScroll() => null;

  void dispose() {
    _scrollController!.removeListener(onScroll);
    listener.remove();
    super.dispose();
  }
}