part of chat;

class ChatRoomBottomBar extends StatelessWidget {
  final TextEditingController? _inputController = TextEditingController();
  final String _chatUuid;

  ChatRoomBottomBar({required String chatUuid}) : _chatUuid = chatUuid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 10,),
        Expanded(
          child: TextField(
            controller: _inputController,
            decoration: InputDecoration(
                hintText: "Write message...",
                hintStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder()
            ),
          ),
        ),
        SizedBox(width: 15,),
        FloatingActionButton(
          onPressed: () {
            if (_inputController!.text.isNotEmpty) {
              API().createMessage(_chatUuid, _inputController!.text);
              _inputController!.clear();
            }
          },
          child: Icon(Icons.send, color: Colors.white, size: 18),
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
      ],
    );
  }
}