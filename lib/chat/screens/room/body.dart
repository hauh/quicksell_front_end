part of chat;

class ChatRoomBody extends StatefulWidget {
  final Chat chat;

  ChatRoomBody(this.chat);

  @override
  _ChatRoomBodyState createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends State<ChatRoomBody> {
  final pagingController = PagingController<int, Message>(firstPageKey: 1);
  late TextEditingController controller;
  late Chat chat;

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) => fetchPage(pageKey));
    notificationQueue.addListener(refresh);
    controller = TextEditingController();
    chat = widget.chat;
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
        pagingController.refresh();
      }
      controller.clear();
    }
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await API().getMessages(chat.uuid, pageKey);
      if (newItems.length >= 10) {
        pagingController.appendPage(newItems, pageKey + 1);
      } else {
        pagingController.appendLastPage(newItems);
      }
    } catch (error) {
      pagingController.error = error;
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
              : PagedListView(
                  reverse: true,
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Message>(
                    itemBuilder: (_, item, __) => MessageTile(item)
                  ),
                )
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
    pagingController.dispose();
    controller.dispose();
    super.dispose();
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
