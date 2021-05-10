part of chat;

class ChatListBody extends StatefulWidget {
  @override
  _ChatListBodyState createState() => _ChatListBodyState();
}

class _ChatListBodyState extends State<ChatListBody> {
  final pagingController = PagingController<int, Chat>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) => fetchPage(pageKey));
    context.appState.notificationQueue.addListener(refresh);
  }

  void refresh() =>
      mounted ? {setState(() {}), pagingController.refresh()} : null;

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await context.api.getChats(pageKey);
      newItems.sort((a, b) =>
          b.latestMessage!.timestamp.compareTo(a.latestMessage!.timestamp));
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
    // return ChatsList();
    return PagedListView<int, Chat>(
      // reverse: true,
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<Chat>(
          firstPageProgressIndicatorBuilder: (context) => Center(),
          itemBuilder: (_, item, __) => ChatTile(item)),
    );
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}

class ChatTile extends StatelessWidget {
  final Chat chat;

  ChatTile(this.chat);

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
          chat.interlocutor.fullName,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        subtitle:
            Text(chat.latestMessage!.text, style: TextStyle(fontSize: 16)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(chat.listing.title),
            Text(context.appState.currency(chat.listing.price)),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ChatRoom(chat)),
        ),
      ),
    );
  }
}
