part of chat;

class ChatRoom extends StatelessWidget {
  final Chat chat;

  ChatRoom(this.chat);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: ChatRoomTopBar(
          chat.subject,
          chat.members.firstWhere(
            (profile) => profile != context.appState.user!.profile,
            orElse: () => context.appState.user!.profile,
          ),
        ),
      ),
      body: ChatRoomBody(chat),
    );
  }
}
