part of chat;

class ChatRoom extends StatelessWidget {
  final Chat _chat;

  ChatRoom({ required Chat chat }) : _chat = chat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: ChatRoomTopBar(chat: _chat),
      ),
      body: ChatRoomBody(chatUuid: _chat.uuid),
    );
  }
}


