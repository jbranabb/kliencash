import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/SelectProjects.dart';
import 'package:kliencash/Screens/Widgets/checkbox_pembulatan.dart';
import 'package:kliencash/Screens/Widgets/datestart_end.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/statusInvoice.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';
import 'package:kliencash/state/bloc/paymentMethod/payment_method_bloc.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kliencash/state/cubit/SelectedDateCubit.dart';
import 'package:kliencash/state/cubit/checkbook_pembulatan.dart';
import 'package:kliencash/state/cubit/count_amount.dart';
import 'package:kliencash/state/cubit/drop_down_rounded.dart';
import 'package:kliencash/state/cubit/dropdown_statusinvoice.dart';
import 'package:kliencash/state/cubit/selectedProjects.dart';
import 'package:kliencash/state/cubit/selectedpaymentMethod.dart';

class AddInovice extends StatefulWidget {
  AddInovice({super.key});

  @override
  State<AddInovice> createState() => _AddInoviceState();
}

class _AddInoviceState extends State<AddInovice> {
  final formatRupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  var idC = TextEditingController();
  var statusC = TextEditingController();
  var pajakC = TextEditingController();
  var discountC = TextEditingController();
  var subtotalC = TextEditingController();
  var totalAmountC = TextEditingController();
  var notes = TextEditingController();
  var titleC = TextEditingController();
  var titleF = FocusNode();
  var notesF = FocusNode();
  var subtotalF = FocusNode();
  var pajakF = FocusNode();
  var discountF = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<CountMount>().setValueRouned(1000);
    context.read<DropdownStatusinvoice>().setStatus(null);
    pajakC.text = '11';
    context.read<CountMount>().setpajak(int.parse(pajakC.text));
    context.read<SelectedPaymentMethod>().reset();
  }

  @override
  Widget build(BuildContext context) {
    var inoviceState = context.watch<DropdownStatusinvoice>().state;
    var roundedValue = context.watch<DropDownRounded>().state;
    var checkbooxRoundedValue = context.watch<CheckbookPembulatan>().state;
    var stateList = context.read<InvoiceBloc>().state;
    var state = context.watch<CountMount>().state;
    var formated = formatRupiah.format(state);
    var display = state <= 0 ? 'Gratis' : formated;
    totalAmountC.text = display;
    var idProjectsState = context.read<SelectedProjects>().state;
    idC.text = idProjectsState['Id'].toString();
    var datevalue = context.watch<Selecteddatecubit>().state;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<CountMount>().reset();
            context.read<SelectedProjects>().reset();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: MyText(
          title: 'Add New Invoices',
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      body: BlocListener<InvoiceBloc, InvoiceState>(
        listener: (context, state) {
          if (state is InvoicePostSucces) {
            Navigator.of(context).pop();
            context.read<InvoiceBloc>().add(ReadInvoice());
            context.read<CountMount>().reset();
            context.read<SelectedProjects>().reset();
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    MyText(title: 'Client Projects', color: Colors.grey),
                    SelectProjecstWidget(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    MyTextFileds(
                      controller: titleC,
                      label: 'Judul Invoice',
                      icon: Icons.receipt,
                      focusNode: titleF,
                      isOtional: false,
                      onEditingCom: () {
                        FocusScope.of(context).requestFocus(subtotalF);
                      },
                    ),
                    MyText(
                      title: 'Subtotal, Pajak & Discount',
                      color: Colors.grey,
                    ),
                    MyTextFileds(
                      controller: subtotalC,
                      label: 'Subtotal',
                      icon: Icons.receipt,
                      focusNode: subtotalF,
                      isOtional: false,
                      textType: TextInputType.number,
                      onChanged: (value) {
                        print(state);
                        context.read<CountMount>().setSubtotal(
                          int.tryParse(subtotalC.text),
                        );
                        var data = int.tryParse(subtotalC.text) ?? 0;
                        var formated = formatRupiah.format(data);
                        subtotalC.value = TextEditingValue(text: formated);
                      },
                      onEditingCom: () {
                        FocusScope.of(context).requestFocus(pajakF);
                      },
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: MyTextFileds(
                        controller: pajakC,
                        label: 'Pajak',
                        icon: Icons.price_change,
                        focusNode: pajakF,
                        isOtional: true,
                        suffix: Icon(
                          Icons.percent,
                          color: Colors.grey,
                          size: 20,
                        ),
                        textType: TextInputType.number,
                        onChanged: (value) {
                          context.read<CountMount>().setpajak(
                            int.tryParse(pajakC.text),
                          );
                        },
                        onEditingCom: () {
                          FocusScope.of(context).requestFocus(discountF);
                        },
                      ),
                    ),
                    Expanded(
                      child: MyTextFileds(
                        controller: discountC,
                        label: 'Discount',
                        icon: Icons.sell_outlined,
                        focusNode: discountF,
                        isOtional: true,
                        suffix: Icon(
                          Icons.percent,
                          color: Colors.grey,
                          size: 20,
                        ),
                        textType: TextInputType.number,
                        onChanged: (value) {
                          context.read<CountMount>().setDisc(
                            int.tryParse(discountC.text),
                          );
                        },
                        onEditingCom: () {
                          FocusScope.of(context).requestFocus(notesF);
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    MyText(title: 'Catatan & DLL ', color: Colors.grey),
                    MyTextFileds(
                      controller: notes,
                      label: "Catatan",
                      icon: Icons.description,
                      focusNode: notesF,
                      isOtional: true,
                      maxlines: 10,
                      onEditingCom: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
                DateStartAndEnd(
                  title: "Tanggal Awal Dan Jatuh Tempo",
                  listener: (_, state) {},
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFiledsReadOnly(
                            controller: totalAmountC,
                            label: "Total (Otomatis)",
                            icon: Icons.attach_money,
                          ),
                        ),
                        StatusInvoice(),
                      ],
                    ),
                    CheckboxPembulatan(),
                  ],
                ),
                // payment method select by id
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: InkWell(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => selectedPayementMethod(),
                    ),
                    child: BlocBuilder<SelectedPaymentMethod, Map<String, dynamic>>(
                      builder: (context, state) {
                        return ListTile(
                          leading: Icon(
                            state['type'] == null
                                ? Icons.credit_card
                                : state['type'].toString().toLowerCase() ==
                                      'bank'
                                ? Icons.account_balance
                                : Icons.account_balance_wallet,
                            color: Colors.grey,
                          ),
                          title: MyText(
                            title: state['name'] ?? 'Select Payement Method',
                          ),
                          subtitle:
                              state['name'] != null &&
                                  state['type'].toLowerCase() != 'cash'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      title:
                                          '${state['type'].toLowerCase() == 'bank' ? 'Rek' : 'Num'}: ${state['number']}',
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    MyText(
                                      title: "A.n: ${state['accountName']}",
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ],
                                )
                              : null,
                          trailing: Icon(Icons.arrow_drop_down_rounded),
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(subtotalC.text);
                    var rawtotalAmoutFormated = totalAmountC.text.replaceAll(
                      RegExp(r'[Rp\s.]'),
                      '',
                    );
                    var totalAmoutFormated =
                        rawtotalAmoutFormated.toLowerCase().contains('gratis')
                        ? 0
                        : int.parse(rawtotalAmoutFormated);
                    validatePost(
                      context,
                      idC.text,
                      subtotalC.text,
                      pajakC.text,
                      discountC.text,
                      titleC.text,
                      notes.text,
                      datevalue[0].toIso8601String(),
                      datevalue[1].toIso8601String(),
                      totalAmoutFormated,
                      inoviceState,
                      checkbooxRoundedValue,
                      int.parse(roundedValue),
                      stateList is InvoiceReadSucces
                          ? stateList.list.length.toString()
                          : stateList.toString(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: MyText(
                    title: "Selesai",
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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

Widget selectedPayementMethod() {
  return Container(
    width: double.maxFinite,
    child: Column(
      children: [
        SizedBox(height: 10),
        Container(
          width: 130,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        SizedBox(height: 30),
        BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
          builder: (context, state) {
            if (state is PaymentMethodSReaducces) {
              if (state.list.isEmpty) {
                return Column(
                  children: [
                    Icon(Icons.payment, size: 40, color: Colors.grey),
                    MyText(
                      title:
                          'Tidak ada Payment Method\nSilahkan tambahkan terlebih dahulu',
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    var data = state.list[index];
                    return ListTile(
                      onTap: () {
                        context.read<SelectedPaymentMethod>().selectablePayment(
                          data.id!,
                        );
                        Navigator.of(context).pop();
                      },
                      leading: Icon(
                        data.type.toLowerCase() == 'bank'
                            ? Icons.account_balance
                            : Icons.account_balance_wallet_rounded,
                        color: Colors.grey,
                      ),
                      title: MyText(title: data.name),
                      trailing: MyText(
                        title: data.type,
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                      subtitle: data.type.toLowerCase() != 'cash'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  title:
                                      '${data.type.toLowerCase() == 'bank' ? 'Rek' : 'Num'}: ${data.number}',
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                MyText(
                                  title: 'A.n: ${data.accountName}',
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ],
                            )
                          : null,
                    );
                  },
                ),
              );
            }
            return Container();
          },
        ),
      ],
    ),
  );
}

void validatePost(
  BuildContext context,
  String id,
  String subtotal,
  String pajak,
  String discount,
  String title,
  String notes,
  String startAt,
  String jatuhTempoAt,
  int totalAmout,
  String? status,
  bool isrounded,
  int roundedValue,
  String statelist,
) {
  var paymentId = context.read<SelectedPaymentMethod>().state['id'];
  if (id.isNotEmpty &&
      subtotal.isNotEmpty &&
      startAt.isNotEmpty &&
      title.isNotEmpty &&
      paymentId != null &&
      jatuhTempoAt.isNotEmpty &&
      status != null) {
    var subtotalFormated = subtotal.replaceAll(RegExp(r'[Rp\s.]'), '');
    var rawLegth = int.parse(statelist) + 1;
    var seprated = rawLegth / 100;
    var listlength = seprated.toString().replaceAll('.', '');
    var date = DateFormat('ddMMyyyy').format(DateTime.now());
    context.read<InvoiceBloc>().add(
      PostInvoice(
        invoiceModel: InvoiceModel(
          projectsId: int.parse(id),
          status: status,
          subtotal: int.parse(subtotalFormated),
          pajak: int.tryParse(pajak) ?? 0,
          discount: int.tryParse(discount) ?? 0,
          title: title,
          notes: notes,
          totalAmount: totalAmout,
          tanggal: startAt,
          jatuhTempo: jatuhTempoAt,
          isRounded: isrounded ? 1 : 0,
          roundedValue: isrounded ? roundedValue : 0,
          paymentMethodId: paymentId,
          invoiceNumber: 'INV-$date-$listlength',
          createdAt: DateTime.now().toIso8601String(),
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(mySnakcbar('Silahkan isi fields terlebih dahulu', null));
  }
}
