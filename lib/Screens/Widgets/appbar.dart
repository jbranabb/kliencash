import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';
import 'package:kliencash/state/cubit/bookstatuslength_cubit.dart';
import 'package:kliencash/state/cubit/toggleSearchUniversal.dart';

AppBar myAppBar(BuildContext context, String title, {List<Widget>? actions}) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Navigator.of(context).pop();
        context.read<BookstatuslengthCubit>().getlength();
        context.read<Togglesearchuniversal>().resetButton();
        context.read<InvoiceBloc>().add(ReadInvoice());
      },
      icon: Icon(Icons.arrow_back, color: Colors.white),
    ),
    actions: actions,
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    title: MyText(title: title, color: Colors.white, fontSize: 18),
  );
}
