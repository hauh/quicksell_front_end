part of chat;

class ChatListBody extends StatefulWidget {
  @override
  _ChatListBodyState createState() => _ChatListBodyState();
}

class _ChatListBodyState extends State<ChatListBody> {
  final Map<String, Chat> loadedChats = {};
  final pagingController = PagingController<int, Chat>(firstPageKey: 0);
  late final messagesSubscription;

  @override
  void initState() {
    messagesSubscription = context.notifications.subscribeToMessages(refresh);
    pagingController.addPageRequestListener((pageKey) => fetchPage(pageKey));
    super.initState();
  }

  void refresh(String chatUuid, Message newMessage) {
    print(chatUuid);
    print(newMessage.text);
    loadedChats[chatUuid] != null
        ? loadedChats[chatUuid]!.updateLastMessage(newMessage)
        : pagingController.refresh();
  }

  void rearrange() {
    pagingController.value = PagingState(
      itemList: List.from(
        pagingController.itemList!
          ..sort((a, b) => b.updateTimestamp.compareTo(a.updateTimestamp)),
      ),
      error: null,
      nextPageKey: pagingController.nextPageKey,
    );
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await context.api.getChats(pageKey);
      newItems.forEach(
        (chat) => loadedChats[chat.uuid] = chat..addListener(rearrange),
      );
      if (mounted)
        newItems.isNotEmpty
            ? pagingController.appendPage(newItems, pageKey + 1)
            : pagingController.appendLastPage([]);
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return ChatsList();
    return PagedListView<int, Chat>(
      // reverse: true,
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<Chat>(
        firstPageProgressIndicatorBuilder: (_) => Center(),
        itemBuilder: (_, chat, __) => ChatTile(chat),
      ),
    );
  }

  @override
  void dispose() {
    messagesSubscription.cancel();
    pagingController.dispose();
    super.dispose();
  }
}

class ChatTile extends StatefulWidget {
  final Chat chat;
  ChatTile(this.chat);

  @override
  State<StatefulWidget> createState() => ChatTileState();
}

class ChatTileState extends State<ChatTile> {
  @override
  void initState() {
    widget.chat.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              NetworkImage("https://source.unsplash.com/random/200x200"),
          maxRadius: 30,
        ),
        title: Text(
          widget.chat.members
              .firstWhere(
                (profile) => profile != context.appState.user!.profile,
                orElse: () => context.appState.user!.profile,
              )
              .name,
        ),
        subtitle: Text(
          widget.chat.lastMessage != null
              ? widget.chat.lastMessage!.text
              : "No messages here yet",
          style: TextStyle(fontSize: 16),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(widget.chat.subject)],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatRoom(widget.chat),
          ),
        ),
      ),
    );
  }
}
