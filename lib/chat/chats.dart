part of chats;

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationRequired(
      child: ChatPage(),
    );
  }
}