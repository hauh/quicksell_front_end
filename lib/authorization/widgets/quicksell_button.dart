import 'package:flutter/material.dart';

class QuicksellButton extends StatelessWidget {
  Function onTap;
  String title;
  bool transparent;

  QuicksellButton({this.onTap, this.title, this.transparent = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: transparent ? BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.blue[900], width: 2),
        ) : BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.blue[900]
        ),
        child: Text(
          title, style: TextStyle(fontSize: 20, color: transparent ? Colors.blue[900] : Colors.white),
        ),
      ),
    );
  }
}