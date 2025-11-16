import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/invoice/add_inovice.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, 'Invoice List'),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<InvoiceBloc>().add(ReadInvoice());
        },
        child: BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceReadSucces) {
              return ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  var list =  state.list[index];
                  return ListTile(title: MyText(title: list.status),);
                },
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddInovice()));
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyText(
              title: '+',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            Icon(Icons.receipt_long_outlined, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
