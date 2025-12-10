import 'dart:io';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/colors_status.dart';
import 'package:kliencash/Screens/Widgets/slideAbleShowModalBottomSheet.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kliencash/Screens/Widgets/SelectProjects.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/picked_pict.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';
import 'package:kliencash/state/bloc/payment/payment_bloc.dart';
import 'package:kliencash/state/cubit/SelectDateAddPayement.dart';
import 'package:kliencash/state/cubit/bookstatuslength_cubit.dart';
import 'package:kliencash/state/cubit/selectedInvoice.dart';
import 'package:kliencash/state/cubit/selectedProjects.dart';
import 'package:kliencash/state/cubit/toggleSearchUniversal.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  var amountC = TextEditingController();
  var amountF = FocusNode();

  var nameSeacrhC = TextEditingController();
  var nameSeacrhF = FocusNode();
  @override
  void dispose() {
    amountC.dispose();
    amountF.dispose();
    nameSeacrhC.dispose();
    nameSeacrhF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<BookstatuslengthCubit>().getlength();
            context.read<SelectedProjects>().reset();
            context.read<Selectedinvoice>().reset();
            context.read<InvoiceBloc>().add(ReadInvoice());
            context.read<SelectDateAddPayement>().reset();
            context.read<PickedPict>().reset();
            context.read<Togglesearchuniversal>().resetButton();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: MyText(
          title: LocaleKeys.addPayment.tr(),
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentPostDataSucces) {
            context.read<SelectedProjects>().reset();
            context.read<Selectedinvoice>().reset();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              mySnakcbar(
                LocaleKeys.successAdded.tr(),
                Theme.of(context).colorScheme.onPrimary,
              ),
            );
            context.read<PaymentBloc>().add(ReadDataPayment());
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                _selectProjectsWhenAddPayment(
                  context,
                  nameSeacrhC,
                  nameSeacrhF,
                ),
                _selectedInvoiceWhenAddPayement(
                  context,
                  nameSeacrhC,
                  nameSeacrhF,
                ),
                BlocBuilder<Selectedinvoice, List<InvoiceModel>>(
                  builder: (context, state) {
                    amountC.text = state.isNotEmpty
                        ? formatCurrency(state[0].totalAmount)
                        : '';
                    return TextFiledsReadOnly(
                      controller: amountC,
                      label: LocaleKeys.amount.tr(),
                      icon: Icons.attach_money,
                    );
                  },
                ),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dateSection(context),
                    _paymentMethodSection(context),
                  ],
                ),
                _pickPicturePayment(context),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      var invoiceId = context
                          .read<Selectedinvoice>()
                          .state[0]
                          .id;
                      var projectsId = context
                          .read<SelectedProjects>()
                          .state['Id'];
                      var paymentMethodId = invoiceId != null
                          ? context
                                .read<Selectedinvoice>()
                                .state[0]
                                .paymentMethodId
                          : null;
                      var amount = invoiceId != null
                          ? context.read<Selectedinvoice>().state[0].totalAmount
                          : null;
                      var tanggalBayar = context
                          .read<SelectDateAddPayement>()
                          .state;
                      var buktiPayment = context.read<PickedPict>().state;
                      print(buktiPayment);
                      _validatePostPayment(
                        context,
                        invoiceId,
                        projectsId,
                        paymentMethodId,
                        amount,
                        tanggalBayar,
                        buktiPayment,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: MyText(
                      title: 'Selesai',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _validatePostPayment(
  BuildContext context,
  int? invoiceId,
  int? projectsId,
  int? paymentMethodId,
  int? amount,
  List<DateTime> tanggalBayar,
  String? buktiPayment,
) {
  if (invoiceId != null &&
      projectsId != null &&
      paymentMethodId != null &&
      amount != null &&
      tanggalBayar.isNotEmpty &&
      buktiPayment != null &&
      buktiPayment.isNotEmpty) {
    print('in validation : $buktiPayment');
    context.read<PaymentBloc>().add(
      PostDataPayment(
        paymentModel: PaymentModel(
          invoiceId: invoiceId,
          paymentMethodId: paymentMethodId,
          amount: amount,
          buktiPayment: buktiPayment,
          tanggalBayar: tanggalBayar[0].toIso8601String(),
        ),
      ),
    );
    context.read<PickedPict>().reset();
  } else {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(mySnakcbar(LocaleKeys.fillAllFieldsRequired.tr(), null));
  }
}

Widget _paymentMethodSection(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  return SizedBox(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      width: width * 0.4,
      child: BlocBuilder<Selectedinvoice, List<InvoiceModel>>(
        builder: (context, state) {
          var paymentMethodSelected = state.isNotEmpty ? state[0] : null;
          return ListTile(
            leading: Icon(
              paymentMethodSelected != null
                  ? paymentMethodSelected.paymentMethod!.type == 'BANK'
                        ? Icons.account_balance
                        : Icons.account_balance_wallet
                  : Icons.account_balance,
              color: Colors.grey,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  title: paymentMethodSelected != null
                      ? paymentMethodSelected.paymentMethod!.type
                      : 'Payment Method',
                  fontSize: 10,
                ),
                if (paymentMethodSelected != null) ...[
                  MyText(
                    title: paymentMethodSelected.paymentMethod!.name,
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    ),
  );
}

Widget _dateSection(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  return SizedBox(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      width: width * 0.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          showDialog(
            context: context,
            builder: (context) {
              context.read<SelectDateAddPayement>().setDateTime([
                DateTime.now(),
              ]);
              return _showSingleDateTime(context);
            },
          );
        },
        child: ListTile(
          leading: Icon(Icons.calendar_month, color: Colors.grey),
          title: BlocBuilder<SelectDateAddPayement, List<DateTime>>(
            builder: (context, state) {
              return MyText(
                title: state.isNotEmpty
                    ? formatDate(state[0].toIso8601String())
                    : LocaleKeys.selectDate.tr(),
                fontSize: 10,
              );
            },
          ),
          trailing: Icon(
            Icons.arrow_drop_down_rounded,
            size: 15,
            color: Colors.grey,
          ),
        ),
      ),
    ),
  );
}

Widget _showSingleDateTime(BuildContext context) {
  return Dialog(
    insetPadding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            calendarType: CalendarDatePicker2Type.single,
            selectedDayHighlightColor: Theme.of(context).colorScheme.onPrimary,
            selectedMonthTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            selectedYearTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            selectedDayTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            weekdayLabelTextStyle: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          value: [DateTime.now()],
          onValueChanged: (value) {
            context.read<SelectDateAddPayement>().setDateTime(value);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<SelectDateAddPayement>().reset();
              },
              child: MyText(title: LocaleKeys.cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: MyText(
                title: LocaleKeys.done.tr(),
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    ),
  );
}

Widget _selectedInvoiceWhenAddPayement(
  BuildContext context,
  TextEditingController nameSeacrhC,
  FocusNode nameSeacrhF,
) {
  var height = MediaQuery.of(context).size.height;
  return InkWell(
    onTap: () {
      var idProjects = context.read<SelectedProjects>().state['Id'];
      idProjects != null
          ? context.read<InvoiceBloc>().add(ReadInvoiceWithId(id: idProjects))
          : null;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => idProjects != null
            ? SizedBox(
                height: height * 0.8,
                width: double.maxFinite,
                child: BlocBuilder<Togglesearchuniversal, bool>(
                  builder: (context, isActiveSearch) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        slideAbleModalBottomSheet(context),
                        BlocBuilder<InvoiceBloc, InvoiceState>(
                          builder: (context, state) {
                            if (state is InvoiceReadSuccesWithId) {
                              if (state.list.isEmpty && !isActiveSearch) {
                                return SizedBox(
                                  height: height * 0.3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.receipt_long_rounded,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                      MyText(
                                        title:
                                            "${LocaleKeys.noProject.tr()}\n${LocaleKeys.addProjectFirst.tr()}",
                                        textAlign: TextAlign.center,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Column(
                                children: [
                                  isActiveSearch
                                      ? textFiledsForSearch(
                                          context,
                                          nameSeacrhC,
                                          nameSeacrhF,
                                          (value) {
                                            context.read<InvoiceBloc>().add(
                                              SearchInvoiceWithId(
                                                value: value.trim(),
                                              ),
                                            );
                                          },
                                        )
                                      : SizedBox.shrink(),
                                  if (isActiveSearch && state.list.isEmpty) ...[
                                    SizedBox(height: 20),
                                    MyText(title: LocaleKeys.emptyFilter.tr()),
                                  ],
                                  SizedBox(height: 10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.list.length,
                                    itemBuilder: (context, index) {
                                      var invoice = state.list[index];
                                      var projects = invoice.projectsModel;
                                      return InkWell(
                                        onTap: () {
                                          context
                                              .read<Selectedinvoice>()
                                              .getbyId(invoice.id!);
                                          Navigator.of(context).pop();
                                        },
                                        child: Card(
                                          child: ListTile(
                                            leading: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.receipt_long_rounded,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                              ),
                                            ),
                                            title: MyText(title: invoice.title),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  title: projects!.agenda,
                                                  color: Colors.grey,
                                                ),
                                                MyText(
                                                  title: formatCurrency(
                                                    invoice.totalAmount,
                                                  ),
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                MyText(
                                                  title:
                                                      invoice
                                                              .paymentMethod!
                                                              .type ==
                                                          'CASH'
                                                      ? invoice
                                                            .paymentMethod!
                                                            .type
                                                      : '${invoice.paymentMethod!.type}: ${invoice.paymentMethod!.name}',
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                            trailing: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: bgcolors(invoice.status),
                                                border: Border.all(
                                                  color: colors(invoice.status),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  6.0,
                                                ),
                                                child: MyText(
                                                  fontSize: 10,
                                                  title:
                                                      invoice.status
                                                          .toLowerCase()
                                                          .contains(
                                                            'installments',
                                                          )
                                                      ? LocaleKeys.installments
                                                            .tr()
                                                            .toUpperCase()
                                                      : invoice.status
                                                            .toLowerCase()
                                                            .contains(
                                                              'down payment',
                                                            )
                                                      ? LocaleKeys.dp
                                                            .tr()
                                                            .toUpperCase()
                                                      : invoice.status
                                                            .toLowerCase()
                                                            .contains(
                                                              'fully paid',
                                                            )
                                                      ? LocaleKeys.fullyPaid
                                                            .tr()
                                                            .toUpperCase()
                                                      : invoice.status,
                                                  color: colors(invoice.status),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    );
                  },
                ),
              )
            : Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 4,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(Icons.work, color: Colors.grey, size: 50),
                  Container(
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    child: MyText(
                      title: LocaleKeys.selectProject.tr() + '.',
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
      );
    },
    child: BlocBuilder<Selectedinvoice, List<InvoiceModel>>(
      builder: (context, state) {
        var checkingData = state.isNotEmpty;
        var data = checkingData ? state[0] : null;
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              Icons.receipt_long_rounded,
              color: checkingData ? Colors.black : Colors.grey,
            ),
            title: MyText(
              title: checkingData
                  ? data!.title
                  : '${LocaleKeys.select} Invoice',
            ),
            subtitle: checkingData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        title: data!.projectsModel!.agenda,
                        color: Colors.grey,
                      ),
                      MyText(
                        title: formatCurrency(data.totalAmount),
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                      MyText(
                        title: data.paymentMethod!.type == 'CASH'
                            ? data.paymentMethod!.type
                            : '${data.paymentMethod!.type}: ${data.paymentMethod!.name}',
                        color: Colors.grey,
                      ),
                    ],
                  )
                : null,
            trailing: checkingData
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: bgcolors(data!.status),
                      border: Border.all(color: colors(data.status)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: MyText(
                        fontSize: 10,
                        title:
                            data.status.toLowerCase().contains('installments')
                            ? LocaleKeys.installments.tr().toUpperCase()
                            : data.status.toLowerCase().contains('down payment')
                            ? LocaleKeys.dp.tr().toUpperCase()
                            : data.status.toLowerCase().contains('fully paid')
                            ? LocaleKeys.fullyPaid.tr().toUpperCase()
                            : data.status,
                        color: colors(data.status),
                      ),
                    ),
                  )
                : Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
          ),
        );
      },
    ),
  );
}

Widget _pickPicturePayment(BuildContext context) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  return Align(
    alignment: Alignment.center,
    child: SizedBox(
      child: BlocBuilder<PickedPict, String>(
        builder: (context, state) {
          if (state.isNotEmpty) {
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(child: Image.file(File(state))),
                );
              },
              child: Container(
                height: height * 0.4,
                width: width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Image.file(
                        height: height * 0.4,
                        width: width * 0.8,
                        File(state),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: IconButton(
                        onPressed: () {
                          context.read<PickedPict>().reset();
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              var picked = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (picked != null) {
                print(picked.path);
                final appDir = await getApplicationDocumentsDirectory();
                final myDir = Directory("${appDir.path}/myImages");
                if (!await myDir.exists()) {
                  await myDir.create(recursive: true);
                }
                final fileName = basename(picked.path);
                final newPath = "${myDir.path}/$fileName";
                final exportPath = await File(picked.path).copy(newPath);
                print('Export Path: ${exportPath.path}');
                context.read<PickedPict>().getImage(exportPath.path);
              }
            },
            child: Container(
              height: height * 0.4,
              width: width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, color: Colors.grey, size: 50),
                    MyText(
                      title: LocaleKeys.uploadPaymentProof.tr(),
                      color: Colors.grey,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget _selectProjectsWhenAddPayment(
  BuildContext context,
  TextEditingController nameSeacrhC,
  FocusNode nameSeacrhF,
) {
  var height = MediaQuery.of(context).size.height;
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
          height: height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
          ),
          child: projectsToAdd(context, height, nameSeacrhC, nameSeacrhF),
        ),
      );
    },
    child: BlocBuilder<SelectedProjects, Map<String, dynamic>>(
      builder: (context, state) {
        var startAt = formatDate(state['startAt'] ?? '2025-12-20T00:00:00');
        var endAt = formatDate(state['endAt'] ?? '2025-12-20T00:00:00');
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: state['agenda'] != null
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work,
                color: state['agenda'] != null
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.grey,
              ),
            ),
            title: state['agenda'] == null ?  MyText(title:  
                                  LocaleKeys.selectProjects.tr() ) : null,
            subtitle: state['agenda'] != null
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              title:
                                  state['agenda'] ??
                                  LocaleKeys.selectProjects.tr(),
                            ),
                            MyText(
                              title: state['client_name'],
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                            MyText(
                              title: formatRupiah.format(
                                state['estimatedValue'],
                              ),
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 4,
                              children: [
                                projectsDate(
                                  startAt,
                                  Colors.green.shade100,
                                  Colors.green,
                                ),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 8,
                                  color: Colors.grey,
                                ),
                                projectsDate(
                                  endAt,
                                  Colors.blue.shade100,
                                  Colors.blue,
                                  icon: Icons.done,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      state['status'] != null
                          ? Container(
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: bgcolors(state['status']),
                                border: Border.all(
                                  color: colors(state['status']),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: MyText(
                                  textAlign: TextAlign.center,
                                  title:
                                      state['status'].toLowerCase().contains(
                                        'pending',
                                      )
                                      ? LocaleKeys.pending.tr().toUpperCase()
                                      : state['status'].toLowerCase().contains(
                                          'on going',
                                        )
                                      ? LocaleKeys.onGoing.tr().toUpperCase()
                                      : state['status'].toLowerCase().contains(
                                          'completed',
                                        )
                                      ? LocaleKeys.completed.tr().toUpperCase()
                                      : state['status'].toLowerCase().contains(
                                          'cancelled',
                                        )
                                      ? LocaleKeys.cancelled.tr().toUpperCase()
                                      : state['status'],
                                  fontSize: 10,
                                  color: colors(state['status']),
                                ),
                              ),
                            )
                          : Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  )
                : null,
          ),
        );
      },
    ),
  );
}
