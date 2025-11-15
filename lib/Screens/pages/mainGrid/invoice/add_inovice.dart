import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/datestart_end.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kliencash/state/cubit/checkbook_pembulatan.dart';
import 'package:kliencash/state/cubit/count_amount.dart';
import 'package:kliencash/state/cubit/drop_down_rounded.dart';
import 'package:kliencash/state/cubit/selectedProjects.dart';

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
  var statusC = TextEditingController();
  var pajakC = TextEditingController();
  var discountC = TextEditingController();
  var subtotalC = TextEditingController();
  var totalAmountC = TextEditingController();
  var startAtC = TextEditingController();
  var jatuhTempoAtc = TextEditingController();
  var notes = TextEditingController();
  var notesF = FocusNode();
  var subtotalF = FocusNode();
  var pajakF = FocusNode();
  var discountF = FocusNode();
  @override
  void initState() {
    super.initState();
    context.read<CountMount>().setValueRouned(1000);
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var state = context.watch<CountMount>().state;
    var formated = formatRupiah.format(state);
    var display = state <= 0 ? 'Gratis' : formated;
    totalAmountC.text = display;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read<CountMount>().reset();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: MyText(title: 'Add New Invoices', color: Colors.white, fontSize: 18),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              SelectProjecstWidget(),
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
                      suffix: Icon(Icons.percent, color: Colors.grey, size: 20),
                      textType: TextInputType.number,
                      onChanged: (value) {
                        context.read<CountMount>().setpajak(
                          int.tryParse(pajakC.text),
                        );
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
                      suffix: Icon(Icons.percent, color: Colors.grey, size: 20),
                      textType: TextInputType.number,
                      onChanged: (value) {
                        context.read<CountMount>().setDisc(
                          int.tryParse(discountC.text),
                        );
                      },
                    ),
                  ),
                ],
              ),
              MyTextFileds(
                controller: notes,
                label: "Catatan",
                icon: Icons.description,
                focusNode: notesF,
                isOtional: true,
                maxlines: 10,
              ),
              DateStartAndEnd(
                title: "Tanggal Awal Dan Jatuh Tempo",
                listener: (_, state) {},
              ),
              Column(
                children: [
                  TextFiledsReadOnly(
                    controller: totalAmountC,
                    label: "Total (Otomatis)",
                    icon: Icons.attach_money,
                  ),
                  BlocBuilder<CheckbookPembulatan, bool>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: state,
                                onChanged: (value) {
                                      context.read<CountMount>().setIsRounded(!state);
                                  context
                                      .read<CheckbookPembulatan>()
                                      .toggleCheckBox();
                                },
                              ),
                              MyText(title: 'Pembulatan', fontSize: 12),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: AnimatedContainer(
                              duration: Durations.medium3,
                              height: state ? height * 0.06 : 0,
                              width: width * 0.21,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300,width: 1.5)
                              ),
                              child: BlocBuilder<DropDownRounded, String>(
                                builder: (context, state) {
                                  List<String> list = ['1000', '500', '100'];
                                  return DropdownButton<String>(
                                    onChanged: (value) {
                                      print('value on change $value');
                                      context.read<DropDownRounded>().setDropDown(value!);
                                      context.read<CountMount>().setValueRouned(int.parse(value));
                                    },
                                    items: list.map(
                                          (value) => DropdownMenuItem(
                                            value: value,
                                            child: MyText(title: value),
                                          ),
                                        )
                                        .toList(),
                                    underline: Container(),
                                    borderRadius: BorderRadius.circular(12),
                                    hint: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MyText(title: state),
                                    )
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  print(pajakC.text);
                  print(subtotalC.text);
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
    );
  }
}

class SelectProjecstWidget extends StatelessWidget {
  const SelectProjecstWidget({super.key});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(width: 1.5, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
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
              child: projectsToAdd(height),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: BlocBuilder<SelectedProjects, Map<String, dynamic>>(
            builder: (context, state) {
              var formatedStart = DateTime.parse(
                state['startAt'] ?? '2025-12-20T00:00:00',
              );
              var startAt = DateFormat('dd-MM-yyyy').format(formatedStart);
              var formatedEnd = DateTime.parse(
                state['endAt'] ?? '2025-12-20T00:00:00',
              );
              var endAt = DateFormat('dd-MM-yyyy').format(formatedEnd);
              return ListTile(
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
                title: MyText(title: state['agenda'] ?? 'Pilih Projects'),
                subtitle: state['agenda'] != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            title: state['client_name'],
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                          MyText(
                            title: "Rp ${state['estimatedValue']}",
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 4,
                            children: [
                              MyText(
                                title: startAt,
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                              MyText(
                                title: "Sd",
                                fontSize: 10,
                                color: Colors.grey.shade400,
                              ),
                              MyText(
                                title: endAt,
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      )
                    : null,
                trailing: state['status'] != null
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: bgcolors(state['status']),
                          border: Border.all(color: colors(state['status'])),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MyText(
                            title: state['status'],
                            fontSize: 10,
                            color: colors(state['status']),
                          ),
                        ),
                      )
                    : Icon(Icons.arrow_drop_down, color: Colors.grey),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget projectsToAdd(double height) {
  return SizedBox(
    height: height * 0.8,
    child: Column(
      children: [
        Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 5,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            if (state is ProjectsSuccesState) {
              if (state.list.isEmpty) {
                return Text('Belum Ada Projects');
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    var list = state.list[index];
                    var formatedStart = DateTime.parse(list.startAt);
                    var startAt = DateFormat(
                      'dd-MM-yyyy',
                    ).format(formatedStart);
                    var formatedEnd = DateTime.parse(list.endAt);
                    var endAt = DateFormat('dd-MM-yyyy').format(formatedEnd);
                    return Material(
                      color: Colors.transparent,
                      child: Card(
                        clipBehavior: Clip.none,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            print(list.id);
                            context.read<SelectedProjects>().selecProjects(
                              list.id!,
                            );
                            Navigator.of(context).pop();
                          },
                          child: ListTile(
                            leading: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.work,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(title: list.agenda, fontSize: 13),
                                MyText(
                                  title: list.client!.name,
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                MyText(
                                  title: "Rp ${list.price}",
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 4,
                                  children: [
                                    MyText(
                                      title: startAt,
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MyText(
                                      title: "Sd",
                                      fontSize: 10,
                                      color: Colors.grey.shade400,
                                    ),
                                    MyText(
                                      title: endAt,
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: bgcolors(list.status),
                                border: Border.all(color: colors(list.status)),
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
                          ),
                        ),
                      ),
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
