import 'package:flutter/material.dart';

class QuicksellEntryField extends StatelessWidget {
  TextEditingController inputController;
  String title;
  bool isPassword;

  QuicksellEntryField({this.inputController, this.title, this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
          SizedBox(height: 10,),
          TextField(
            style: TextStyle(height: 1,),
            controller: inputController,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 0, style: BorderStyle.none,
                ),
              ),
              fillColor: Colors.white,
              filled: true
            )
          )
        ],
      ),
    );
  }
}