import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  MyText({super.key, required this.title,
  this.color, this.fontSize, this.fontWeight, this.overflow, this.textAlign
  });
  String title;
  TextAlign? textAlign;
  TextOverflow? overflow;
  Color? color;
  double? fontSize;
  FontWeight?  fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.visible,
      style: GoogleFonts.poppins(
        color: color  ??  Colors.black,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,  
      ),
      );
  }
}
