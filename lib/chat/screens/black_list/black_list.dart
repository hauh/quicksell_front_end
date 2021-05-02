part of chat;

class BlackList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       leading: IconButton(
         icon: Icon(Icons.arrow_back, size: 30,),
         onPressed: () { Navigator.pop(context); },
       ),
       title: Text("Black list"),
     ),
     body: Center(child: Text("Black list here"),)
   );
  }
}