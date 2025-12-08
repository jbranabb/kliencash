import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/Screens/pages/pdf/pdfViwer.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/operasional/operasional_bloc.dart';
import 'package:kliencash/state/cubit/selectedInvoice.dart';

class DetailInvoice extends StatelessWidget {
  const DetailInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Selectedinvoice, List<InvoiceModel>>(
      builder: (context, state) {
        if (state.isEmpty) {
          return Scaffold(body: Center(child: Text('No invoice selected')));
        }
        var invoice = state[0];
        var project = invoice.projectsModel!;
        var client = invoice.clientModel!;
        int valueDiscount = (invoice.subtotal * (invoice.discount! / 100))
            .toInt();
        int valueTax = (invoice.subtotal * (invoice.pajak! / 100)).toInt();
        var formatedValueDiskon = formatCurrency(valueDiscount);
        var formatedValueTax = formatCurrency(valueTax);

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            title: MyText(
              title: LocaleKeys.invoiceDetails.tr(),
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildCard(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(
                          context,
                          LocaleKeys.invoiceInformation.tr(),
                          Icons.receipt_long_rounded,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(title: LocaleKeys.invoiceNumber.tr(), fontSize: 10),
                                MyText(
                                  title: invoice.invoiceNumber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: bgcolors(invoice.status),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4,
                                ),
                                child: MyText(
                                  title: invoice.status.toUpperCase(),
                                  color: colors(invoice.status),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(title: LocaleKeys.projectTitle.tr(), fontSize: 10),
                            MyText(
                              title: invoice.title,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            projectsDate(
                              invoice.tanggal,
                              Colors.blue.shade100,
                              Colors.blue,
                              Icons.play_circle_outline_rounded,
                              LocaleKeys.issued.tr(),
                            ),
                            Icon(Icons.arrow_forward),
                            projectsDate(
                              invoice.jatuhTempo,
                              Colors.red.shade100,
                              Colors.red,
                              Icons.event_busy,
                              LocaleKeys.dueDate,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          spacing: 2,
                          children: [
                            Icon(
                              Icons.date_range,
                              color: Colors.grey,
                              size: 12,
                            ),
                            MyText(
                              title:
                                  "${LocaleKeys.created.tr()} ${formatDateDetail(invoice.createdAt)}",
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildCard(
                        context,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              context,
                              LocaleKeys.clientInformation.tr(),
                              Icons.person,
                            ),
                            SizedBox(height: 16),
                            _buildInfoRow(
                              LocaleKeys.clientName,
                              client.name,
                              isBold: true,
                            ),
                            SizedBox(height: 8),
                            _buildInfoRow(LocaleKeys.project, project.agenda),
                            if (project.desc != null) ...[
                              SizedBox(height: 8),
                              _buildInfoRow(LocaleKeys.phoneNumber, client.handphone),
                              _buildInfoRow(LocaleKeys.phoneNumber, client.alamat),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildCard(
                        context,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              context,
                              LocaleKeys.financialDetails,
                              Icons.account_balance_wallet,
                            ),
                            SizedBox(height: 16),
                            _buildInfoRow(
                              LocaleKeys.projectPrice.tr(),
                              formatCurrency(project.price),
                            ),
                            BlocBuilder<OperasionalBloc, OperasionalState>(
                              builder: (context, state) {
                                if (state is OperasionalReadSucces) {
                                  var data = state.list
                                      .where((e) => e.projectId == project.id)
                                      .toList();
                                  if (data.isNotEmpty) {
                                    return Column(
                                      children: [
                                        SizedBox(height: 8),
                                        _buildInfoRow('${LocaleKeys.opeartional}:', ''),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            var listOp = data[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: _buildInfoRow(
                                                '• ${listOp.title}',
                                                formatCurrency(listOp.amount),
                                                labelSize:
                                                    listOp.title.length > 12
                                                    ? 10
                                                    : 12,
                                                valueSize: 12,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                }
                                return SizedBox.shrink();
                              },
                            ),
                            SizedBox(height: 8),
                            _buildInfoRow(
                              'Subtotal',
                              formatCurrency(invoice.subtotal),
                            ),
                            SizedBox(height: 8),
                            invoice.pajak != 0
                                ? _buildInfoRow(
                                    LocaleKeys.tax.tr(),
                                    "${invoice.pajak}% (+ $formatedValueTax)",
                                  )
                                : _buildInfoRow('Tax', "${invoice.pajak}%"),
                            SizedBox(height: 8),
                            invoice.discount != 0
                                ? _buildInfoRow(
                                    LocaleKeys.discount.tr(),
                                    '${invoice.discount}% (- $formatedValueDiskon)',
                                  )
                                : _buildInfoRow(
                                    LocaleKeys.discount.tr(),
                                    '${invoice.discount}%',
                                  ),
                            SizedBox(height: 8),
                            if (invoice.isRounded == 1) ...[
                              MyText(
                                title: LocaleKeys.rounding.tr(),
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              _buildInfoRow(
                                LocaleKeys.rounding.tr(),
                                invoice.roundedValue.toString(),
                              ),
                            ],
                            Divider(
                              height: 24,
                              thickness: 1,
                              color: Colors.grey.shade200,
                            ),
                            invoice.totalAmount != 0
                                ? _buildInfoRow(
                                    'Total ${LocaleKeys.amount.tr()}',
                                    formatCurrency(invoice.totalAmount),
                                    isBold: true,
                                    labelSize: 14,
                                    valueSize: 16,
                                    valueColor: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  )
                                : _buildInfoRow(
                                    'Total ${LocaleKeys.amount.tr()}',
                                    LocaleKeys.free.tr(),
                                    isBold: true,
                                    labelSize: 14,
                                    valueSize: 16,
                                    valueColor: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildCard(
                        context,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              context,
                              'Project Details',
                              Icons.work,
                            ),
                            SizedBox(height: 16),
                            _buildInfoRow(
                              'Project Status',
                              project.status,
                              valueColor: colors(project.status),
                            ),
                            if (project.desc != null &&
                                project.desc!.isNotEmpty) ...[
                              _buildInfoRow(
                                'Project ${LocaleKeys.description.tr()}',
                                project.desc.toString(),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  projectsDate(
                                    project.startAt,
                                    Colors.green.shade100.withOpacity(0.3),
                                    Colors.green,
                                    Icons.play_circle_outline_rounded,
                                    LocaleKeys.start.tr(),
                                  ),
                                  Icon(Icons.arrow_forward),
                                  projectsDate(
                                    project.endAt,
                                    Colors.blue.shade100.withOpacity(0.3),
                                    Colors.blue,
                                    Icons.done,
                                    LocaleKeys.done.tr(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => Pdfviwer()));
            },
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            icon: Icon(Icons.picture_as_pdf, color: Colors.white),
            label: MyText(
              title: 'Print Invoice',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  Widget projectsDate(
    String project,
    Color colorbg,
    Color color,
    IconData icon,
    String title,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorbg,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 4,
              children: [
                Icon(icon, size: 14, color: color),
                MyText(
                  title: title,
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            MyText(
              title: formatDateDetail(project),
              fontSize: 12,
              fontWeight: title.toLowerCase().contains('jatuh tempo')
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: child,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onPrimary),
        SizedBox(width: 8),
        MyText(
          title: title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    double? labelSize,
    double? valueSize,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: MyText(
            title: label,
            fontSize: labelSize ?? 14,
            color: Colors.grey[600]!,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: MyText(
            title: value,
            fontSize: valueSize ?? 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
