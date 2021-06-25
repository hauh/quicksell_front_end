part of chat;

class ChatRoomBody extends StatefulWidget {
  final Chat chat;

  ChatRoomBody(this.chat);

  @override
  _ChatRoomBodyState createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends State<ChatRoomBody> {
  final pagingController = PagingController<int, Message>(firstPageKey: 0);
  late TextEditingController controller;
  final ValueNotifier<bool> sendingMessage = ValueNotifier(false);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) => fetchPage(pageKey));
    widget.chat.addListener(newMessage);
    controller = TextEditingController();
    super.initState();
  }

  void newMessage() {
    pagingController.value = PagingState(
      itemList: [widget.chat.lastMessage!, ...pagingController.itemList ?? []],
      nextPageKey: pagingController.nextPageKey,
      error: null,
    );
  }

  void sendMessage() async {
    var text = controller.text.trim();
    if (text.isNotEmpty) {
      sendingMessage.value = true;
      try {
        widget.chat.updateLastMessage(
          await context.api.createMessage(widget.chat.uuid, text),
        );
      } catch (error) {
        context.notify(error.toString());
      }
      sendingMessage.value = false;
    }
    controller.clear();
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await context.api.getMessages(widget.chat.uuid, pageKey);
      if (mounted)
        newItems.isNotEmpty
            ? pagingController.appendPage(newItems, pageKey + 1)
            : pagingController.appendLastPage(newItems);
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PagedListView(
            reverse: true,
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<Message>(
              itemBuilder: (_, item, __) => MessageTile(item),
            ),
          ),
        ),
        SizedBox(height: 10),
        ChatRoomBottomBar(
          onPressed: sendMessage,
          controller: controller,
          sendingMessage: sendingMessage,
        ),
        SizedBox(height: 10)
      ],
    );
  }

  @override
  void dispose() {
    widget.chat.removeListener(newMessage);
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
    if (message.author == context.appState.user!.profile) {
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
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              Text(
                context.appState.datetime(message.timestamp),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 5),
              Text(
                message.text,
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatRoomBottomBar extends StatelessWidget {
  final Function() onPressed;
  final TextEditingController controller;
  final ValueListenable<bool> sendingMessage;

  ChatRoomBottomBar({
    required this.onPressed,
    required this.controller,
    required this.sendingMessage,
  });

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
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 15),
        ValueListenableBuilder<bool>(
          valueListenable: sendingMessage,
          builder: (_, sendingInProgress, __) => sendingInProgress
              ? FloatingActionButton(
                  onPressed: null,
                  backgroundColor: Colors.blue,
                  child: CircularProgressIndicator(),
                )
              : FloatingActionButton(
                  onPressed: onPressed,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.send, color: Colors.white, size: 18),
                ),
        ),
        SizedBox(width: 15),
      ],
    );
  }
}
