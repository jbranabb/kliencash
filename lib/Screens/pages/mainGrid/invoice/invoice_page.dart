import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/Screens/pages/mainGrid/invoice/add_inovice.dart';
import 'package:kliencash/Screens/pages/mainGrid/invoice/detail_invoice.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kliencash/state/bloc/operasional/operasional_bloc.dart';
import 'package:kliencash/state/cubit/selectedInvoice.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceBloc>().add(ReadInvoice());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: myAppBar(context, LocaleKeys.invoiceList.tr()),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        onRefresh: () async {
          context.read<InvoiceBloc>().add(ReadInvoice());
        },
        child: BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceReadSucces) {
              if (state.list.isEmpty) {
                return _buildEmptyState(context);
              }
              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  var invoice = state.list[index];
                  return _buildInvoiceCard(context, invoice);
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddInovice()));
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(Icons.add, color: Colors.white),
        label: MyText(
          title: LocaleKeys.invoice.tr(),
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, color: Colors.grey[400], size: 80),
          SizedBox(height: 16),
          MyText(
            title: LocaleKeys.noInvoice.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700]!,
          ),
          SizedBox(height: 8),
          MyText(
            title: LocaleKeys.addInvoiceFirst.tr(),
            color: Colors.grey[500]!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(BuildContext context, InvoiceModel invoice) {
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final invoiceDate = DateTime.parse(invoice.tanggal);
    final dueDate = DateTime.parse(invoice.jatuhTempo);
    final formattedDate = DateFormat('dd MMM yyyy').format(invoiceDate);
    final formattedDueDate = DateFormat('dd MMM yyyy').format(dueDate);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.read<Selectedinvoice>().getbyId(invoice.id!);
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => DetailInvoice()));
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.receipt,
                          size: 18,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        SizedBox(width: 6),
                        MyText(
                          title: invoice.invoiceNumber,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700]!,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: bgcolors(invoice.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: MyText(
                        title: invoice.status.toUpperCase(),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors(invoice.status),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Divider(height: 1, color: Colors.grey[200]),
                SizedBox(height: 12),
                MyText(
                  title: invoice.title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.work, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    MyText(
                      title: invoice.projectsModel!.agenda,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]!,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    MyText(
                      title: invoice.clientModel!.name,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]!,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    MyText(
                      title: formatCurrency(invoice.projectsModel!.price),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]!,
                    ),
                  ],
                ),

                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // _buildFinancialRow(
                      //   'Estimasi',
                      //   formatCurrency(invoice.projectsModel!.price),
                      //   Colors.grey[700]!,
                      // ),
                      // _buildFinancialRow('Operasional', 'value', Colors.grey),
                      _operasional(invoice),
                      _buildFinancialRow(
                        'Subtotal',
                        formatRupiah.format(invoice.subtotal),
                        Colors.blueGrey,
                      ),
                      if (invoice.pajak != null && invoice.pajak! > 0) ...[
                        SizedBox(height: 6),
                        _buildFinancialRow(
                          'Pajak (${invoice.pajak}%)',
                          '+ ${formatRupiah.format(invoice.subtotal * invoice.pajak! / 100)}',
                          Colors.deepOrange,
                        ),
                      ],
                      if (invoice.discount != null &&
                          invoice.discount! > 0) ...[
                        SizedBox(height: 6),
                        _buildFinancialRow(
                          'Diskon (${invoice.discount}%)',
                          '- ${formatRupiah.format(invoice.subtotal * invoice.discount! / 100)}',
                          Colors.green,
                        ),
                      ],
                      SizedBox(height: 8),
                      Divider(height: 1, color: Colors.grey[300]),
                      SizedBox(height: 8),
                      _buildFinancialRow(
                        'TOTAL',
                        invoice.totalAmount == 0
                            ? 'GRATIS'
                            : formatRupiah.format(invoice.totalAmount),
                        Theme.of(context).colorScheme.onPrimary,
                        isBold: true,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                // Due Date Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.event, size: 14, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        MyText(
                          title: formattedDate,
                          fontSize: 12,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.alarm,
                          size: 14,
                          color: _isDueSoon(dueDate)
                              ? Colors.red
                              : Colors.grey[500],
                        ),
                        SizedBox(width: 4),
                        MyText(
                          title: '${LocaleKeys.dueDate.tr()} $formattedDueDate',
                          fontSize: 12,
                          color: _isDueSoon(dueDate)
                              ? Colors.red
                              : Colors.grey[600]!,
                          fontWeight: _isDueSoon(dueDate)
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _operasional(InvoiceModel invoice) {
    return BlocBuilder<OperasionalBloc, OperasionalState>(
      builder: (context, state) {
        if (state is OperasionalReadSucces) {
          var data = state.list
              .where((e) => e.projectId == invoice.projectsId)
              .toList();
          if (data.isNotEmpty) {
            var totalAmount = 0;
            for (var amount in data) {
              totalAmount += amount.amount;
            }
            return Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.factory, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    MyText(
                      title: "${LocaleKeys.opeartional}: ",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]!,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var listOp = data[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyText(
                                  title: '• ${listOp.title} ',
                                  fontSize: 10,
                                  color: Colors.grey.shade700,
                                ),
                                MyText(
                                  title: formatCurrency(listOp.amount),
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          title:'${LocaleKeys.operationalTotal}: ',
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color:Colors.grey.shade600,
                        ),
                        MyText(
                          title:
                              formatCurrency(totalAmount),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color:Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade300),
              ],
            );
          }
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildFinancialRow(
    String label,
    String value,
    Color color, {
    bool isBold = false,
    double fontSize = 13,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(
          title: label,
          fontSize: fontSize,
          color: Colors.grey[600]!,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
        ),
        MyText(
          title: value,
          fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  bool _isDueSoon(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    return difference <= 3 && difference >= 0;
  }
}
