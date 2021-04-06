import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuicksellTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'quick',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.display1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        children: [
          TextSpan(
            text: 'sell',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ]
      ),
    );
  }
}