part of chats;

class BlackList extends StatefulWidget {
  @override
  _BlackListState createState() => _BlackListState();
}

class _BlackListState extends State<BlackList> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       leading: IconButton(
         icon: Icon(Icons.arrow_back, size: 30,),
         onPressed: () {
           Navigator.pop(context);
         },
       ),
       title: Text("Black list"),
     ),
     body: Center(
       child: Text("Black list here"),
     )
   );
  }
}