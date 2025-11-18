import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/colors_status.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/cubit/selectedInvoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/widgets.dart';

Future<Uint8List> generatePDF(BuildContext context) async {
  var state = context.read<Selectedinvoice>().state;
  var invoice = state[0];
  var projects = invoice.projectsModel!;
  var client = invoice.clientModel!;
  var primaryColor = PdfColor.fromInt(
    Theme.of(context).colorScheme.primary.value,
  );
  var onprimaryColor = PdfColor.fromInt(
    Theme.of(context).colorScheme.onPrimary.value,
  );

  var pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        // color: primaryColor,
                        borderRadius: pw.BorderRadius.circular(12),
                      ),
                      child: pw.Padding(
                        padding: pw.EdgeInsets.all(0),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            MyTextPdf(
                              title: 'Judul Invoice',
                              fontSize: 20,
                              color: onprimaryColor,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            MyTextPdf(
                              title: 'pinky wedding',
                              fontSize: 16,
                              color: PdfColors.grey,
                            ),
                            MyTextPdf(
                              title: client.name,
                              fontWeight: pw.FontWeight.bold,
                              textAlign: pw.TextAlign.end,
                              fontSize: 16,
                            ),
                            MyTextPdf(
                              title: client.alamat,
                              textAlign: pw.TextAlign.end,
                            ),
                            MyTextPdf(
                              title:
                                  '${client.countryCode} ${client.handphone}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    MyTextPdf(
                      title: 'INVOICE',
                      color: onprimaryColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                    ),
                    MyTextPdf(
                      title: invoice.invoiceNumber,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    MyTextPdf(
                      title: formatDateDetail(invoice.createdAt),
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 8),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    // color: primaryColor,
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(16),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        MyTextPdf(title: 'Bill To :'),
                        MyTextPdf(
                          title: client.name,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 16,
                        ),
                        MyTextPdf(title: client.alamat),
                        MyTextPdf(
                          title: '${client.countryCode} ${client.handphone}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.SizedBox(height: 8),
                    MyTextPdf(title: 'Diterbitkan :'),
                    MyTextPdf(title: formatDateDetail(invoice.tanggal)),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                    MyTextPdf(title: 'Jatuh Tempo :'),
                    MyTextPdf(
                      title: formatDateDetail(invoice.jatuhTempo),
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.red,
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: MyTextPdf(title: 'Item Transactions'),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder(
              horizontalInside: pw.BorderSide(color: PdfColors.grey500),
            ),
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                children: [
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: MyTextPdf(title: "Agenda"),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: MyTextPdf(title: "Status"),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: MyTextPdf(title: "Subtotal"),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey50,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                children: [
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: MyTextPdf(title: projects.agenda),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: MyTextPdf(
                        title: projects.status,
                        color: pdfcolors(projects.status),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: MyTextPdf(title: formatCurrency(invoice.subtotal)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [pw.SizedBox(height: 8)],
                ),
              ),
              pw.SizedBox(width: 30),
              // subtotal discount pajak etc
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  children: [
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        MyTextPdf(title: 'Subtotal'),
                        MyTextPdf(title: formatCurrency(invoice.subtotal)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        if (invoice.pajak != 0) ...[
                          MyTextPdf(title: 'Pajak (${invoice.pajak}%)'),
                          MyTextPdf(

                            color: PdfColors.orange600,
                            title:
                                " + ${formatCurrency(invoice.subtotal * (invoice.pajak! / 100))}",
                          ),
                        ],
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        if (invoice.discount != 0) ...[
                          MyTextPdf(title: 'Discount (${invoice.discount}%)'),
                          MyTextPdf(
                            color: PdfColors.green,
                            title:
                                "- ${formatCurrency(invoice.subtotal * (invoice.discount! / 100))}",
                          ),
                        ],
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        if (invoice.isRounded != 0) ...[
                          MyTextPdf(title: 'Pembulatan'),
                          MyTextPdf(title: invoice.roundedValue.toString()),
                        ],
                      ],
                    ),
                    if (invoice.isRounded != 0) ...[pw.SizedBox(height: 8)],
                    pw.Divider(color: PdfColors.grey, height: 3),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        MyTextPdf(
                          title: 'TOTAL',
                          fontWeight: pw.FontWeight.bold,
                          color: onprimaryColor,
                          fontSize: 16,
                        ),
                        MyTextPdf(
                          title: invoice.totalAmount != 0
                              ? formatCurrency(invoice.totalAmount)
                              : "GRATIS",
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 18,
                          color: onprimaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                MyTextPdf(
                  title: 'Informasi Pembayaran: ',
                  fontWeight: pw.FontWeight.bold,
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    MyTextPdf(title: 'Bayar: '),
                    MyTextPdf(
                      title: invoice.status,
                      color: invoice.status.toLowerCase() == 'lunas'
                          ? PdfColors.blue700
                          : PdfColors.orange600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ],
                ),
                MyTextPdf(
                  title: 'Transfer BANK: ',
                  fontWeight: pw.FontWeight.bold,
                ),
                pw.Row(
                  children: [
                    MyTextPdf(title: 'BANK: '),
                    MyTextPdf(title: 'BCA', fontWeight: pw.FontWeight.bold),
                  ],
                ),
                pw.Row(
                  children: [
                    MyTextPdf(title: 'No. Rekening: '),
                    MyTextPdf(
                      title: '12345678',
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    MyTextPdf(title: 'A.n: '),
                    MyTextPdf(
                      title: 'pinkweeding',
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
            pw.Align(
              alignment: pw.Alignment.bottomLeft,
              child: pw.Container(
                child: pw.Padding(
                  padding: pw.EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      MyTextPdf(title: '* Catatan'),
                      MyTextPdf(title: invoice.notes!),
                    ],
                  ),
                ),
              ),
            ),
          ],
          pw.SizedBox(height: 32,),
          MyTextPdf(
            title: 'Invoice ini di buat otomatis oleh sistem KlienCash',
            fontSize: 12,
            color: PdfColors.grey
          ),
        ],
      ),
    ),
  );
  return pdf.save();
}
