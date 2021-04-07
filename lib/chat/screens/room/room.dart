part of chat;

class ChatRoom extends StatelessWidget {
  final Chat chat;

  ChatRoom(this.chat);
  ChatRoom.initChat(Listing listing) : chat = Chat.prepareFromListing(listing);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: ChatRoomTopBar(listing: chat.listing),
      ),
      body: ChatRoomBody(chat),
    );
  }
}
