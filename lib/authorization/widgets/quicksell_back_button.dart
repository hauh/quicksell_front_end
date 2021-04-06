import 'package:flutter/material.dart';

class QuicksellBackButton extends StatelessWidget {
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 27,),
            ),
            Text('Back', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}