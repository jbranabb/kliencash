import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:kliencash/state/cubit/SelectedClient.dart';
import 'package:kliencash/state/cubit/SelectedDateCubit.dart';
import 'package:kliencash/state/cubit/statusProjectrs.dart';
import 'package:intl/intl.dart';

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
  Widget build(BuildContext context) {
    List<DateTime> rangeDatePickerValueWithDefaultValue = [
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      DateTime.now().add(Duration(days: 7)),
    ];
    context.read<StatusprojectrsCubit>().setStatus(null);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    context.read<Selecteddatecubit>().setDate(
      rangeDatePickerValueWithDefaultValue,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<StatusprojectrsCubit>().setStatus(null);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: MyText(
          title: 'Projects Client',
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: BlocListener<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if(state is ProjectsPostSuccesState){
            Navigator.of(context).pop();
            context.read<ProjectsBloc>().add(ReadDataProjects());
            ScaffoldMessenger.of(context).showSnackBar(mySnakcbar('Berhasil Membuat Data',
             Theme.of(context).colorScheme.onPrimary));
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: BoxBorder.all(
                      width: 1.4,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: BlocBuilder<Selectedclient, Map<String, dynamic>>(
                    builder: (context, state) {
                      var stateIsnotEmpty = state['name'] != null;
                      idC.text = state['Id'].toString();
                      return ListTile(
                        title: MyText(
                          title: stateIsnotEmpty
                              ? state['name']
                              : 'Pilih Client',
                        ),
                        leading: stateIsnotEmpty
                            ? Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: MyText(
                                  title: state['name']
                                      .toString()
                                      .characters
                                      .first,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Icon(Icons.person, color: Colors.grey),
                        subtitle: stateIsnotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    title:
                                        "${state['countryCode']} ${state['handphone']}",
                                    color: Colors.grey,
                                  ),
                                  MyText(
                                    title: state['almat'].toString(),
                                    color: Colors.grey,
                                  ),
                                ],
                              )
                            : null,
                        trailing: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
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
                              child: userstoAdd(context, height),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                MyTextFileds(
                  controller: agendaC,
                  label: "Agenda",
                  icon: Icons.work,
                  focusNode: agendaF,
                  onEditingCom: () {
                    FocusScope.of(context).requestFocus(descF);
                  },
                ),
                MyTextFileds(
                  controller: descC,
                  label: "Deskripsi",
                  icon: Icons.description,
                  focusNode: descF,
                  onEditingCom: () {
                    FocusScope.of(context).requestFocus(priceF);
                  },
                ),
                MyTextFileds(
                  controller: priceC,
                  label: "Harga Awal",
                  icon: Icons.attach_money_outlined,
                  focusNode: priceF,
                  onEditingCom: () {
                    FocusScope.of(context).unfocus();
                    // tutup keyboard pake apa?
                  },
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(title: 'Tanggal Mulai Dan Selesai'),
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => showDateTime(context),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: BoxBorder.all(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    BlocConsumer<
                                      Selecteddatecubit,
                                      List<DateTime>
                                    >(
                                      listener: (context, state) {
                                        startDateC.text = state[0].toIso8601String();
                                        endtDateC.text = state[1].toIso8601String();
                                      },
                                      builder: (context, state) {
                                        if (state.length > 1) {
                                          var startDate = DateFormat(
                                            "dd-MM-yyyy",
                                          ).format(state[0]);
                                          var endDate = DateFormat(
                                            "dd-MM yyyy",
                                          ).format(state[1]);
                                          return Row(
                                            spacing: 10,
                                            children: [
                                              Icon(
                                                Icons.calendar_month,
                                                color: Colors.grey,
                                              ),
                                              MyText(
                                                title: startDate,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              MyText(title: 'Sd'),
                                              MyText(
                                                title: endDate,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          );
                                        }
                                        return Row(
                                          spacing: 10,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: Colors.grey,
                                            ),
                                            MyText(title: 'Pilih Tanggal'),
                                          ],
                                        );
                                      },
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    spacing: 10,
                    children: [
                      MyText(title: 'Status:'),
                      TextFieldsDropDown(),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    var status = context.read<StatusprojectrsCubit>().state;
                    validatePost(
                      idC.text,
                      agendaC.text,
                      descC.text,
                      priceC.text,
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
  if (id.isNotEmpty &&
      agenda.isNotEmpty &&
      desc.isNotEmpty &&
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

Widget userstoAdd(BuildContext context, double height) {
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
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    var list = state.list[index];
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
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: MyText(
                              title: list.name.characters.first,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: MyText(title: list.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                title: "${list.countryCode} ${list.handphone}",
                                color: Colors.grey,
                              ),
                              MyText(title: list.alamat, color: Colors.grey),
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
