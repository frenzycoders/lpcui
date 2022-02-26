import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatelessWidget {
  CustomHeader({
    Key? key,
    required this.stringA,
    required this.stringB,
  }) : super(key: key);
  String stringA;
  String stringB;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stringA,
            style: GoogleFonts.firaSans(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
          ),
          Text(
            ' ' + stringB,
            style: GoogleFonts.firaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
