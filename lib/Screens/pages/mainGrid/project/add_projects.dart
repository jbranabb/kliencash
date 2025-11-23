import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/datestart_end.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/selectClientsWidget.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/statusWidget.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:kliencash/state/cubit/SelectedClient.dart';
import 'package:kliencash/state/cubit/SelectedDateCubit.dart';
import 'package:kliencash/state/cubit/statusProjectrs.dart';
import 'package:intl/intl.dart';

var formatRupiah = NumberFormat.currency(
  decimalDigits: 0,
  locale: 'id_ID',
  symbol: 'Rp ',
);

class AddProjects extends StatefulWidget {
  const AddProjects({super.key});
  @override
  State<AddProjects> createState() => _AddProjectsState();
}

class _AddProjectsState extends State<AddProjects> {
  var agendaC = TextEditingController();
  var agendaF = FocusNode();
  var descC = TextEditingController();
  var descF = FocusNode();
  var priceC = TextEditingController();
  var priceF = FocusNode();

  var idC = TextEditingController();
  var startDateC = TextEditingController();
  var endtDateC = TextEditingController();
  var status = TextEditingController();
  @override
  void dispose() {
    agendaC.dispose();
    agendaF.dispose();
    descC.dispose();
    descF.dispose();
    priceC.dispose();
    priceF.dispose();
    idC.dispose();
    startDateC.dispose();
    endtDateC.dispose();
    status.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> rangeDatePickerValueWithDefaultValue = [
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      DateTime.now().add(Duration(days: 7)),
    ];
    context.read<StatusprojectrsCubit>().setStatus(null);
    context.read<Selecteddatecubit>().setDate(
      rangeDatePickerValueWithDefaultValue,
    );
    var stateDate = context.read<Selecteddatecubit>().state;
    startDateC.text = stateDate[0].toIso8601String();
    endtDateC.text = stateDate[1].toIso8601String();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<Selectedclient>().reset();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: MyText(title: 'Add Projects', color: Colors.white, fontSize: 18),
      ),
      body: BlocListener<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectsPostSuccesState) {
            Navigator.of(context).pop();
            context.read<Selectedclient>().reset();
            context.read<ProjectsBloc>().add(ReadDataProjects());
            ScaffoldMessenger.of(context).showSnackBar(
              mySnakcbar(
                'Berhasil Membuat Data',
                Theme.of(context).colorScheme.onPrimary,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    MyText(title: 'Client in Projects', color: Colors.grey),
                    SelectClientsWidget(
                      listener: (_, state) {
                        idC.text = state['Id'].toString();
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    MyText(title: 'Agenda & Deskripsi', color: Colors.grey),
                    MyTextFileds(
                      controller: agendaC,
                      label: "Agenda",
                      icon: Icons.work,
                      focusNode: agendaF,
                      isOtional: false,
                      onEditingCom: () {
                        FocusScope.of(context).requestFocus(descF);
                      },
                    ),
                  ],
                ),
                MyTextFileds(
                  controller: descC,
                  label: "Deskripsi",
                  icon: Icons.description,
                  focusNode: descF,
                  isOtional: true,
                  maxlines: 10,
                  onEditingCom: () {
                    FocusScope.of(context).requestFocus(priceF);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    MyText(title: 'Harga & Info Lainya', color: Colors.grey),
                    MyTextFileds(
                      controller: priceC,
                      label: "Harga Awal",
                      icon: Icons.attach_money_outlined,
                      focusNode: priceF,
                      isOtional: false,
                      textType: TextInputType.number,
                      onEditingCom: () {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (value) {
                        var formated = formatRupiah.format(
                          int.parse(priceC.text),
                        );
                        priceC.value = TextEditingValue(text: formated);
                      },
                    ),
                  ],
                ),
                DateStartAndEnd(
                  listener: (_, state) {
                    startDateC.text = state[0].toIso8601String();
                    endtDateC.text = state[1].toIso8601String();
                  },
                ),
                Statuswidget(),
                ElevatedButton(
                  onPressed: () {
                    var subtotalFormated = priceC.text.replaceAll(
                      RegExp(r'[Rp\s.]'),
                      '',
                    );
                    var selectedClientState = context
                        .read<Selectedclient>()
                        .state;
                    var status = context.read<StatusprojectrsCubit>().state;
                    validatePost(
                      selectedClientState['Id'].toString(),
                      agendaC.text,
                      descC.text,
                      subtotalFormated,
                      startDateC.text,
                      endtDateC.text,
                      status,
                      context,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: MyText(
                    title: 'Selesai',
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

void validatePost(
  String id,
  String agenda,
  String desc,
  String price,
  String startDate,
  String enddate,
  String? status,
  BuildContext context,
) {
  print(id);
  print(agenda);
  print(desc);
  print(price);
  print(startDate);
  print(status);
  if (id.isNotEmpty &&
      agenda.isNotEmpty &&
      price.isNotEmpty &&
      startDate.isNotEmpty &&
      status != null) {
    context.read<ProjectsBloc>().add(
      PostDataProjects(
        projectsModel: ProjectsModel(
          clientId: int.parse(id),
          agenda: agenda,
          desc: desc,
          price: int.parse(price),
          startAt: startDate,
          endAt: enddate,
          status: status,
          createdAt: DateTime.now().toIso8601String(),
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(mySnakcbar('Mohon isi semua fileds', null));
  }
}

Widget userstoAdd(BuildContext context, double height, double width) {
  return BlocBuilder<ClientBloc, ClientState>(
    builder: (context, state) {
      if (state is ClientSucces) {
        if (state.list.isEmpty) {
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 0.0,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.4,
                  // alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, size: 40, color: Colors.grey),
                      MyText(
                        title:
                            "Tidak ada Clients Saat ini silahkan\ntambah client baru",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox(
          height: height * 0.8,
          child: Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 0.0,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    var list = state.list[index];
                    var rawName = state.list[index].name
                        .toString()
                        .trim()
                        .split(' ');
                    var displayedName = rawName.length == 1
                        ? state.list[index].name.toString().characters.first
                        : "${rawName[0].characters.first}${rawName[1].characters.first}";
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          context.read<Selectedclient>().selectedClient(
                            list.id!,
                          );
                          Navigator.of(context).pop();
                        },
                        child: ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(-2, 2),
                                  blurRadius: 10,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: MyText(
                              title: displayedName.toUpperCase(),
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: MyText(title: list.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 2,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  MyText(
                                    title:
                                        "${list.countryCode} ${list.handphone}",
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 2,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:3.0),
                                    child: Icon(
                                      Icons.location_on_sharp,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child: MyText(
                                      title: list.alamat,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    },
  );
}

Widget showDateTime(BuildContext context) {
  List<DateTime> rangeDatePickerValueWithDefaultValue = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    DateTime.now().add(Duration(days: 7)),
  ];
  var state = context.read<Selecteddatecubit>().state;
  return Dialog(
    insetPadding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            calendarType: CalendarDatePicker2Type.range,
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
          value: state.length > 1
              ? state
              : rangeDatePickerValueWithDefaultValue,
          onValueChanged: (value) {
            context.read<Selecteddatecubit>().setDate(value);
          },
          onDisplayedMonthChanged: (value) {
            // context.read<Selecteddatecubit>().setDate(value);
            print('displayed value $value');
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 19,
          children: [
            TextButton(
              onPressed: () {
                context.read<Selecteddatecubit>().setDate([]);
                // print('batal > $state');
                print(state.length > 1);
                print(state.length);
                print(state);
                Navigator.of(context).pop();
              },
              child: MyText(title: 'Batal'),
            ),
            TextButton(
              onPressed: () {
                var state = context.read<Selecteddatecubit>().state;
                // print(state.length);
                print(state.length > 1);
                print(state.length);
                print(state);

                if (state.isEmpty) {
                  // print('satu');
                  context.read<Selecteddatecubit>().setDate(
                    rangeDatePickerValueWithDefaultValue,
                  );
                  Navigator.of(context).pop();
                } else if (state.length == 2) {
                  // print('dua');
                  Navigator.of(context).pop();
                } else {
                  // print('tiga');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: MyText(title: 'Terjadi Kesalahan'),
                      content: MyText(
                        title: 'Silahkan pilih tanggal Mulai dan Selesai',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: MyText(title: 'Oke'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: MyText(title: 'Oke'),
            ),
          ],
        ),
      ],
    ),
  );
}
