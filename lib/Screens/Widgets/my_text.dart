import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
class MyTextPdf extends pw.StatelessWidget {
  MyTextPdf({required this.title,
  this.color, this.fontSize, this.fontWeight, this.overflow, this.textAlign
  });
  String title;
  pw.TextAlign? textAlign;
  pw.TextOverflow? overflow;
  PdfColor? color;
  double? fontSize;
  pw.FontWeight?  fontWeight;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Text(
      title,
      textAlign: textAlign ?? pw.TextAlign.start,
      overflow: overflow ?? pw.TextOverflow.visible,
      style: pw.TextStyle(
        color: color ?? PdfColors.black,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? pw.FontWeight.normal,  
      ),
      );
  }
}
