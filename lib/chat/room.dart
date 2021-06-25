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

class ChatRoomTopBar extends StatelessWidget {
  final String subject;
  final Profile interlocutor;

  ChatRoomTopBar(this.subject, this.interlocutor);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.teal.shade200, Colors.teal.shade500],
        ),
      ),
      child: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              flex: 3,
              child: ChatRoomTopBarInterlocutor(interlocutor),
            ),
            Expanded(
              child: Container(
                child: VerticalDivider(
                  color: Colors.black,
                  thickness: 1.0,
                  endIndent: 7.0,
                  indent: 7.0,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ChatRoomTopBarListing(subject),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatRoomTopBarInterlocutor extends StatelessWidget {
  final Profile interlocutor;

  ChatRoomTopBarInterlocutor(this.interlocutor);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CircleAvatar(
            backgroundImage:
                NetworkImage("https://source.unsplash.com/random/200x200"),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(interlocutor.name, textAlign: TextAlign.start),
              Text(interlocutor.online ? "Online" : "Offline"),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatRoomTopBarListing extends StatelessWidget {
  final String subject;

  ChatRoomTopBarListing(this.subject);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              subject,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Expanded(
          child: CircleAvatar(
            backgroundImage:
                NetworkImage("https://source.unsplash.com/random/200x200"),
          ),
        ),
      ],
    );
  }
}
