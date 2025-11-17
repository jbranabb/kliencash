import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/Screens/pages/mainGrid/invoice/add_inovice.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';
import 'package:intl/intl.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    var formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return Scaffold(
      appBar: myAppBar(context, 'Invoice List'),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        onRefresh: () async {
          context.read<InvoiceBloc>().add(ReadInvoice());
        },
        child: BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceReadSucces) {
              if (state.list.isEmpty) {
                return SizedBox(
                  height: 160,
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.receipt_long_outlined, color: Colors.grey,  size: 40,),
                      MyText(
                        textAlign: TextAlign.center,
                        title:
                            'Belum ada Invoice Saat ini\nSilahkan Tambahkan Terlebih Dahulu',
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  var list = state.list[index];
                  var rawStartAt = DateTime.parse(list.tanggal);
                  var rawendAt = DateTime.parse(list.jatuhTempo);
                  final formatedStart = DateFormat(
                    'dd-MM-yyyy',
                  ).format(rawStartAt);
                  final formatedEndAt = DateFormat(
                    'dd-MM-yyyy',
                  ).format(rawendAt);
                  var formatedPrice = formatRupiah.format(list.totalAmount);
                  var formatedSubtotal = formatRupiah.format(list.subtotal);
                  return ListTile(
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              title: list.projectsModel!.agenda,
                              fontWeight: FontWeight.w600,
                            ),
                            MyText(
                              title: list.clientModel!.name,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                            Row(
                              children: [
                                MyText(title: 'Subtotal: ', color: Colors.grey),
                                MyText(
                                  title: formatedSubtotal,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyText(title: 'Pajak: ', color: Colors.grey),
                                MyText(
                                  title: '${list.pajak}%',
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyText(title: 'Discount: ', color: Colors.grey),
                                MyText(
                                  title: '${list.discount}%',
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyText(title: 'Total: ', color: Colors.grey),
                                MyText(
                                  title: list.totalAmount == 0
                                      ? 'Gratis'
                                      : formatedPrice,
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          spacing: 2,
                          children: [
                            MyText(
                              title: list.invoiceNumber,
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: bgcolors(list.status),
                                border: BoxBorder.all(
                                  color: colors(list.status),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: MyText(
                                  title: list.status,
                                  fontSize: 10,
                                  color: colors(list.status),
                                ),
                              ),
                            ),
                            MyText(
                              title: 'Jatuh Tempo:',
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            MyText(
                              title: formatedEndAt,
                              fontSize: 10,
                              color: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyText(
              title: '+',
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
            Icon(Icons.receipt_long_outlined),
          ],
        ),
      ),
    );
  }
}
