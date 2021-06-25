part of chat;

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationRequired(
      builder: (_) => ChatList(),
    );
  }
}
