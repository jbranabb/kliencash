import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/pages/pdf.dart';
import 'package:printing/printing.dart';
class Pdfviwer extends StatelessWidget {
  const Pdfviwer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, 'Invoice PDF Preview'),
      body: PdfPreview(
        build: (format) => generatePDF(context) ,
      ),
    );
  }
}