import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextComponents extends StatelessWidget {
  const TextComponents({
    super.key,
    required this.txt,
    this.color = Colors.black,
    this.txtSize = 16,
    this.fw = FontWeight.normal,
    this.textAlign = TextAlign.left,
  });

  final Color color;
  final double txtSize;
  final FontWeight fw;
  final TextAlign textAlign;
  final String txt;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: GoogleFonts.mulish(
        color: color,
        fontSize: txtSize,
        fontWeight: fw,
      ),
      textAlign: textAlign,
    );
  }
}
