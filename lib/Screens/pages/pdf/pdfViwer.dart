import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kliencash/Screens/pages/pdf/pdf_en.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/pages/pdf/pdf.dart';
import 'package:kliencash/state/bloc/operasional/operasional_bloc.dart';
import 'package:kliencash/state/bloc/users/users_bloc.dart';
import 'package:kliencash/state/cubit/selectedInvoice.dart';
import 'package:kliencash/state/cubit/toggleLang.dart';
import 'package:printing/printing.dart';

class Pdfviwer extends StatelessWidget {
  const Pdfviwer({super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.read<Selectedinvoice>().state;
    var invoice = state[0];
    return Scaffold(
      appBar: myAppBar(context, LocaleKeys.invoicePdfPreview.tr()),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, user) {
          if (user is UsersSucces) {
            var rawData =
                context.read<OperasionalBloc>().state as OperasionalReadSucces;
            return BlocBuilder<Togglelang, String>(
              builder: (context, state) {
                if(state == 'en'){
                  return PdfPreview(
                  allowPrinting: true,
                  canDebug: false,
                  pdfFileName:
                      '${invoice.invoiceNumber}-${invoice.projectsModel!.agenda}',
                  build: (format) => generatePDFEn(context, user.list, rawData),
                );
                }
                return PdfPreview(
                  allowPrinting: true,
                  canDebug: false,
                  pdfFileName:
                      '${invoice.invoiceNumber}-${invoice.projectsModel!.agenda}',
                  build: (format) => generatePDF(context, user.list, rawData),
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
