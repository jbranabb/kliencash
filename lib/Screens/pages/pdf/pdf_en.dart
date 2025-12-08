import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/Screens/Widgets/colors_status.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/operasional/operasional_bloc.dart';
import 'package:kliencash/state/cubit/selectedInvoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/widgets.dart';

Future<Uint8List> generatePDFEn(
  BuildContext context,
  List<User> userState,
  OperasionalReadSucces opdata,
) async {
  var state = context.read<Selectedinvoice>().state;
  var invoice = state[0];
  var projects = invoice.projectsModel!;
  var client = invoice.clientModel!;
  var paymentM = invoice.paymentMethod!;
  var finalOpData = opdata.list
      .where((e) => e.projectId == projects.id)
      .toList();
  var onprimaryColor = PdfColor.fromInt(
    Theme.of(context).colorScheme.onPrimary.value,
  );
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  var user = userState[0];
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
                              title: invoice.title,
                              fontSize: 20,
                              color: onprimaryColor,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            // pw.SizedBox(height: 12,),
                            MyTextPdf(
                              title: user.username,
                              fontSize: 16,
                              color: PdfColors.grey700,
                            ),
                            MyTextPdf(
                              title: user.namaPerusahaaan,
                              fontWeight: pw.FontWeight.bold,
                              textAlign: pw.TextAlign.start,
                              fontSize: 16,
                            ),
                            MyTextPdf(
                              title: user.alamat,
                              textAlign: pw.TextAlign.start,
                            ),
                            MyTextPdf(
                              title: '${user.countryCode} ${user.phoneNumber}',
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
                    MyTextPdf(title: 'Issued :'),
                    MyTextPdf(title: formatDateDetail(invoice.tanggal)),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                    MyTextPdf(title: 'Due Date :'),
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
              horizontalInside: pw.BorderSide(color: PdfColors.grey100),
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
                      child: MyTextPdf(title: "Total"),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: MyTextPdf(title: "Status"),
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
                      child: MyTextPdf(title: formatCurrency(invoice.subtotal)),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: MyTextPdf(
                        title: projects.status.toUpperCase(),
                        color: pdfcolors(projects.status),
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (finalOpData.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child:pw.Container(
              width: width * 0.7,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Column(
                  children: [
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,        
                      child: MyTextPdf(
                        title: 'Operational Cost / Additional',
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                    ...finalOpData.map((items) {
                      return pw.SizedBox(
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            MyTextPdf(
                              title: "- ${items.title}",
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                            MyTextPdf(
                              title: "- ${formatCurrency(items.amount)}",
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey700,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ), 
            ),
            pw.SizedBox(height: 10),
          ],
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
                          MyTextPdf(title: 'Tax (${invoice.pajak}%)'),
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
                          MyTextPdf(title: 'Rounding'),
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
                              : "FREE",
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
                  title: 'Transaction Information: ',
                  fontWeight: pw.FontWeight.bold,
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    MyTextPdf(title: 'Payment: '),
                    MyTextPdf(
                      title: invoice.status.toLowerCase() == 'lunas' ?  'FULLY PAID' : 'DP / PARTIAL',
                      color: invoice.status.toLowerCase() == 'lunas'
                          ? PdfColors.blue700
                          : PdfColors.orange600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ],
                ),
                MyTextPdf(
                  title: 'Payment Method: ',
                  fontWeight: pw.FontWeight.bold,
                ),
                if (paymentM.type.toString().toLowerCase() == 'cash') ...[
                  MyTextPdf(title: 'Cash'),
                ],
                if (paymentM.type.toString().toLowerCase() != 'cash' &&
                    paymentM.number != null &&
                    paymentM.accountName != null) ...[
                  pw.Row(
                    children: [
                      MyTextPdf(title: '${paymentM.type}: '),
                      MyTextPdf(
                        title: paymentM.name,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      MyTextPdf(
                        title: paymentM.type.toString() == 'BANK'
                            ? 'Bank Account Number: '
                            : 'Number: ',
                      ),
                      MyTextPdf(
                        title: paymentM.number!,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      MyTextPdf(title: 'OBO: '),
                      MyTextPdf(
                        title: paymentM.accountName!,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ],
                  ),
                ],
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
                      MyTextPdf(title: '* Notes'),
                      MyTextPdf(title: invoice.notes!),
                    ],
                  ),
                ),
              ),
            ),
          ],
          pw.SizedBox(height: 20),
          MyTextPdf(
            title: 'This invoice is automatically generated by the Client Cash system.',
            fontSize: 12,
            color: PdfColors.grey,
          ),
        ],
      ),
    ),
  );
  return pdf.save();
}
