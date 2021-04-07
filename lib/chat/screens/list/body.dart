part of chat;

class ChatListBody extends StatefulWidget {
  @override
  _ChatListBodyState createState() => _ChatListBodyState();
}

class _ChatListBodyState extends State<ChatListBody> {
  @override
  void initState() {
    super.initState();
    notificationQueue.addListener(refresh);
  }

  void refresh() => mounted ? setState(() {}) : null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().getChats(), //TODO: Lazy loading for chats
      builder: (context, AsyncSnapshot<List<Chat>> snapshot) => snapshot.hasData
          ? snapshot.data!.isEmpty
              ? Center(
                  child: Text(
                    "You do not have any messages yet!",
                    style: TextStyle(fontSize: 23, color: Colors.grey),
                  ),
                )
              : ChatsList(snapshot.data!)
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class ChatsList extends StatelessWidget {
  final List<Chat> chatsList;

  ChatsList(this.chatsList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 7),
      itemCount: chatsList.length,
      itemBuilder: (_, index) => ChatTile(chatsList[index]),
    );
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
            Text(AppState.currencyFormat(chat.listing.price)),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ChatRoom(chat)),
        ),
      ),
    );
  }
}
