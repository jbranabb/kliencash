import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/pages/pdf.dart';
import 'package:kliencash/state/bloc/users/users_bloc.dart';
import 'package:kliencash/state/cubit/selectedInvoice.dart';
import 'package:printing/printing.dart';

class Pdfviwer extends StatelessWidget {
  const Pdfviwer({super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.read<Selectedinvoice>().state;
    var invoice = state[0];
    return Scaffold(
      appBar: myAppBar(context, 'Invoice PDF Preview'),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if(state is UsersSucces){
            return PdfPreview(
            allowPrinting: true,
            canDebug: false,
            pdfFileName:
                '${invoice.invoiceNumber}-${invoice.projectsModel!.agenda}',
            build: (format) => generatePDF(context, state.list),
          ); 
          }
          return SizedBox.shrink(); 
        },
      ),
    );
  }
}
