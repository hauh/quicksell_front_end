part of chat;

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: ChatListTopBar()
      ),
      body: ChatListBody(),
    );
  }
}