
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

    case "menunggu":
      return Colors.orange.shade100;
    case "sedang berjalan":
      return Colors.blue.shade100;
    case "selesai":
      return Colors.green.shade100;
    case "dibatalkan":
      return Colors.red.shade100;

    // status invocie
      
    case "lunas":
      return Colors.blue.shade100;
    case "fully paid":
      return Colors.blue.shade100;

    case "uang muka":
      return Colors.orange.shade100;
    case "down payment":
      return Colors.orange.shade100;
    
    case "cicilan":
      return Colors.yellow.shade100;
    case "installments":
      return Colors.yellow.shade100;

    default:
      return Colors.grey.shade100;
  }
}

Color colors(String state) {
  switch (state.toLowerCase()) {
    // status projects
    case "pending":
      return Colors.orange.shade700;
    case "on going":
      return Colors.blue.shade700;
    case "completed":
      return Colors.green.shade700;
    case "cancelled":
      return Colors.red;
    case "menunggu":
      return Colors.orange.shade700;
    case "sedang berjalan":
      return Colors.blue.shade700;
    case "selesai":
      return Colors.green.shade700;
    case "dibatalkan":
      return Colors.red;

      // status invoice
    case "lunas":
      return Colors.blue.shade700;
    case "fully paid":
      return Colors.blue.shade700;

    case "uang muka":
      return Colors.orange.shade700;
    case "down payment":
      return Colors.orange.shade700;
    
    case "cicilan":
      return Colors.yellow.shade800;
    case "installments":
      return Colors.yellow.shade800;
    default:
      return Colors.grey.shade500;
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

    case "menunggu":
      return PdfColors.orange700;
    case "sedang berjalan":
      return PdfColors.blue700;
    case "selesai":
      return PdfColors.green700;
    case "dibatalkan":
      return PdfColors.red;

       case "lunas":
      return PdfColors.blue;
    case "fully paid":
      return PdfColors.blue;
    case "uang muka":
      return PdfColors.orange700;
    case "down payment":
      return PdfColors.orange700;
    
    case "cicilan":
      return PdfColors.yellow800;
    case "installments":
      return PdfColors.yellow800;
    default:
      return PdfColors.grey;
  }
}
