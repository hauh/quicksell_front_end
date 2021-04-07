part of chat;

class ChatRoomBody extends StatefulWidget {
  final Chat chat;

  ChatRoomBody(this.chat);

  @override
  _ChatRoomBodyState createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends State<ChatRoomBody> {
  late Chat chat;
  late TextEditingController controller;

  @override
  void initState() {
    chat = widget.chat;
    controller = TextEditingController();
    notificationQueue.addListener(refresh);
    super.initState();
  }

  void refresh() => mounted ? setState(() {}) : null;

  void sendMessage() {
    if (controller.text.isNotEmpty) {
      if (chat.uuid.isEmpty) {
        API()
            .createChat(
          chat.interlocutor.uuid,
          chat.listing.uuid,
          controller.text,
        )
            .then((newChat) {
          chat.uuid = newChat.uuid;
          chat.latestMessage = newChat.latestMessage;
          refresh();
        });
      } else {
        API().createMessage(chat.uuid, controller.text).then((_) => refresh());
      }
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: chat.uuid.isEmpty
              ? Center(
                  child: Text(
                    "No messages here yet",
                    style: TextStyle(fontSize: 23, color: Colors.grey),
                  ),
                )
              : FutureBuilder(
                  future: API().getChatMessages(chat.uuid),
                  builder: (_, AsyncSnapshot<List<Message>> snapshot) =>
                      snapshot.hasData
                          ? MessagesList(snapshot.data!)
                          : Center(child: CircularProgressIndicator()),
                ),
        ),
        SizedBox(height: 10),
        ChatRoomBottomBar(
          onPressed: sendMessage,
          controller: controller,
        ),
        SizedBox(height: 10)
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class MessagesList extends StatelessWidget {
  final List<Message> messages;

  MessagesList(this.messages);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemBuilder: (_, index) => MessageTile(messages[index]),
      itemCount: messages.length,
    );
  }
}

class MessageTile extends StatelessWidget {
  final Message message;

  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    var color, alignment;
    if (message.is_yours) {
      color = Colors.blue[200];
      alignment = Alignment.topRight;
    } else {
      color = Colors.grey.shade200;
      alignment = Alignment.topLeft;
    }
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: alignment,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color,
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            message.text,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}

class ChatRoomBottomBar extends StatelessWidget {
  final Function() onPressed;
  final TextEditingController controller;

  ChatRoomBottomBar({required this.onPressed, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: "Write a message...",
                hintStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder()),
          ),
        ),
        SizedBox(width: 15),
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Colors.blue,
          elevation: 0,
          child: Icon(Icons.send, color: Colors.white, size: 18),
        ),
        SizedBox(width: 15),
      ],
    );
  }
}
