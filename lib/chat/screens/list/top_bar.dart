part of chat;

class ChatListTopBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "quick",
        style: Theme.of(context).textTheme.headline4,
        children: [
          TextSpan(
            text: "sell",
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class ChatListTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade500,
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.blue.shade200, Colors.blue.shade500],
          )),
      child: SafeArea(
          child: Row(
        children: <Widget>[
          Expanded(
              child: IconButton(
                  icon: Icon(Icons.remove_circle, size: 30),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BlackList())))),
          Expanded(
            flex: 6,
            child: Center(child: ChatListTopBarTitle()),
          ),
          Expanded(
              child: IconButton(
            icon: Icon(Icons.search, size: 30),
            onPressed: () => print("Hello"),
          )),
        ],
      )),
    );
  }
}
