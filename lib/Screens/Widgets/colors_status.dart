
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

Color bgcolors(String state) {
  switch (state.toLowerCase()) {
    case "pending":
      return Colors.orange.shade100;
    case "on going":
      return Colors.blue.shade100;
    case "completed":
      return Colors.green.shade100;
    case "cancelled":
      return Colors.red.shade100;
    default:
      return Colors.grey.shade100;
  }
}

Color colors(String state) {
  switch (state.toLowerCase()) {
    case "pending":
      return Colors.orange.shade700;
    case "on going":
      return Colors.blue.shade700;
    case "completed":
      return Colors.green.shade700;
    case "cancelled":
      return Colors.red;
    default:
      return Colors.grey.shade100;
  }
}
PdfColor pdfcolors(String state) {
  switch (state.toLowerCase()) {
    case "pending":
      return PdfColors.orange700;
    case "on going":
      return PdfColors.blue700;
    case "completed":
      return PdfColors.green;
    case "cancelled":
      return PdfColors.red;
    default:
      return PdfColors.grey;
  }
}
