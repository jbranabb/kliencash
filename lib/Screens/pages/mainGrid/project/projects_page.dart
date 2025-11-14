import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kliencash/Screens/Widgets/datestart_end.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/selectClientsWidget.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/statusWidget.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/add_projects.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kliencash/state/cubit/SelectedClient.dart';
import 'package:kliencash/state/cubit/SelectedDateCubit.dart';
import 'package:kliencash/state/cubit/statusProjectrs.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  var agendaC = TextEditingController();
  var agendaF = FocusNode();
  var descC = TextEditingController();
  var descF = FocusNode();
  var priceC = TextEditingController();
  var priceF = FocusNode();

  var clientIdC = TextEditingController();
  var startAtC = TextEditingController();
  var endAtC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProjectsBloc>().add(ReadDataProjects());
        },
        child: CustomScrollView(
          slivers: [
            BlocConsumer<ProjectsBloc, ProjectsState>(
              listener: (context, state) {
                if (state is ProjectsDeleteSuccesState) {
                  context.read<ProjectsBloc>().add(ReadDataProjects());
                  ScaffoldMessenger.of(context).showSnackBar(
                    mySnakcbar(
                      "Berhasil Menghapus Projects",
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                } else if(state is ProjectsEditSuccesState){
                  context.read<ProjectsBloc>().add(ReadDataProjects());
                  ScaffoldMessenger.of(context).showSnackBar(
                    mySnakcbar(
                      "Berhasil Mengedit Projects",
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProjectsSuccesState) {
                  if (state.list.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(height: height * 0.18),
                          Icon(Icons.cancel, color: Colors.grey, size: 60),
                          MyText(
                            title:
                                'Belum Ada Projects Saat Ini\n Silahkan Tambahkan Terlebih Dahulu',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return SliverList.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      var list = state.list[index];
                      var formatedDateStart = DateTime.parse(list.startAt);
                      var startDate = DateFormat(
                        'dd-MM-yyyy',
                      ).format(formatedDateStart);
                      var formatedDateEnd = DateTime.parse(list.endAt);
                      var endDate = DateFormat(
                        'dd-MM-yyyy',
                      ).format(formatedDateEnd);

                      var rawCreatedAt = DateTime.parse(list.createdAt);
                      var createdAt = DateFormat(
                        'dd-MM-yyyy HH:mm',
                      ).format(rawCreatedAt);
                      return InkWell(
                        onLongPress: () {
                          context.read<Selectedclient>().selectedClient(
                            list.clientId,
                          );
                          context.read<Selecteddatecubit>().setDate([
                            formatedDateStart,
                            formatedDateEnd,
                          ]);
                          context.read<StatusprojectrsCubit>().setStatus(
                            list.status,
                          );
                          startAtC.text = formatedDateStart.toIso8601String();
                          endAtC.text = formatedDateEnd.toIso8601String();
                          clientIdC.text = list.clientId.toString();
                          showDialog(
                            context: context,
                            builder: (context) => editProjects(
                              context,
                              height,
                              agendaC,
                              agendaF,
                              list.agenda,
                              descC,
                              descF,
                              list.desc,
                              priceC,
                              priceF,
                              list.price,
                              clientIdC,
                              list.clientId,
                              startAtC,
                              list.startAt,
                              endAtC,
                              list.endAt,
                              list.status,
                              list.id!,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 0.3,
                              ),
                            ),
                          ),
                          child: Slidable(
                            key: Key(index.toString()),
                            endActionPane: ActionPane(
                              motion: DrawerMotion(),
                              extentRatio: 0.22,
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    validateDeleteProjects(
                                      list.agenda,
                                      list.id!,
                                      context,
                                    );
                                  },
                                  icon: Icons.delete,
                                  label: "Delete",
                                  autoClose: true,
                                  backgroundColor: Colors.red,
                                ),
                              ],
                            ),
                            child: ListTile(
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width * 0.6,
                                        child: MyText(
                                          title: list.agenda,
                                          fontSize: 12,
                                        ),
                                      ),
                                      MyText(
                                        title: list.client!.name ,
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      MyText(
                                        title: "Rp ${list.price}",
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(height: 4),
                                      if (list.desc != null && list.desc!.isNotEmpty) ...[
                                        SizedBox(
                                          width: width * 0.6,
                                          child: MyText(
                                            title: list.desc!,
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                      ],
                                      MyText(
                                        title: "Cretaed at",
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      MyText(
                                        title: createdAt,
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  // trailing
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: bgcolors(list.status),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: MyText(
                                            title: list.status,
                                            fontSize: 10,
                                            color: colors(list.status),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      MyText(
                                        title: startDate,
                                        fontSize: 10,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      MyText(
                                        title: 'Sd',
                                        fontSize: 10,
                                        color: Colors.grey.shade400,
                                      ),
                                      MyText(
                                        title: endDate,
                                        fontSize: 10,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return SliverToBoxAdapter(child: Container());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AddProjects()));
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

Widget editProjects(
  BuildContext context,
  double height,

  TextEditingController agendaC,
  FocusNode agendaF,
  String agendaBefore,

  TextEditingController descC,
  FocusNode descF,
  String? descBefore,

  TextEditingController priceC,
  FocusNode priceF,
  int priceBefore,

  TextEditingController clientIdC,
  int clientIdBefore,

  TextEditingController startAt,
  String startAtBefore,

  TextEditingController endAt,
  String endAtBefore,

  String statusBefore,

  int id,
) {
  agendaC.text = agendaBefore;
  descC.text = descBefore ?? '';
  priceC.text = priceBefore.toString();
  return SingleChildScrollView(
    child: Dialog(
      insetPadding: EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    title: 'Edit Projects',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.cancel, color: Colors.grey, size: 20),
                  ),
                ],
              ),
              SelectClientsWidget(
                listener: (_, state) {
                  clientIdC.text = state['Id'].toString();
                },
              ),
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
              MyTextFileds(
                controller: descC,
                label: "Deskripsi",
                icon: Icons.description,
                focusNode: descF,
                isOtional: true,
                onEditingCom: () {
                  print(descC.text); // ada
                  FocusScope.of(context).requestFocus(priceF);
                },
              ),
              MyTextFileds(
                controller: priceC,
                label: "Price",
                icon: Icons.attach_money,
                focusNode: priceF,
                isOtional: false,
                onEditingCom: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              DateStartAndEnd(
                listener: (context, state) {
                  startAt.text = state[0].toIso8601String();
                  endAt.text = state[1].toIso8601String();
                },
              ),
              Statuswidget(),
              ElevatedButton(
                onPressed: () {
                  var stateStatus = context.read<StatusprojectrsCubit>().state;
                  validateEditProjects(
                    context,
                    agendaC.text,
                    agendaBefore,
                    descC.text,
                    descBefore,
                    priceC.text,
                    priceBefore,
                    clientIdC.text,
                    clientIdBefore.toString(),
                    startAt.text,
                    startAtBefore,
                    endAt.text,
                    endAtBefore,
                    stateStatus ?? "",
                    statusBefore,
                    id,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: MyText(
                  title: 'Selesai',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void validateEditProjects(
  BuildContext context,
  String agendaC,
  String agendaBefore,
  String? descC,
  String? descBefore,
  String priceC,
  int priceBefore,
  String clientIdC,
  String clientIdCBefore,
  String startAt,
  String startAtBefore,
  String endAt,
  String endAtBefore,
  String status,
  String statusBefore,
  int id,
) {
  print(descC);
  if (agendaC == agendaBefore &&
      descC == descBefore &&
      priceC == priceBefore.toString() &&
      startAt == startAtBefore &&
      endAt == endAtBefore &&
      status == statusBefore &&
      clientIdC == clientIdCBefore) {
    ScaffoldMessenger.of(context).showSnackBar(
      mySnakcbar(
        'Tidak ada yang berubah',
        Theme.of(context).colorScheme.onPrimary,
      ),
    );
    Navigator.of(context).pop();
  } else if (agendaC.isNotEmpty &&
      priceC.isNotEmpty &&
      clientIdC.isNotEmpty &&
      startAt.isNotEmpty) {
    print(descC);
    print(agendaC);
    print(descBefore);
    context.read<ProjectsBloc>().add(
      EditDataProjects(
        projectsModel: ProjectsModel(
          clientId: int.parse(clientIdC),
          agenda: agendaC,
          desc: descC,
          price: int.parse(priceC),
          startAt: startAt,
          endAt: endAt,
          status: status,
          createdAt: DateTime.now().toIso8601String(),
        ),
        id: id,
      ),
    );
    Navigator.of(context).pop();
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: MyText(title: 'Terjadi Kesalahan'),
        content: MyText(title: 'Silahkan isi semua fileds terlebih dahulu'),
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
}

void validateDeleteProjects(String title, int id, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: MyText(title: 'Hapus Projects $title?'),
      content: MyText(title: 'Apakah Anda yakin ingin menghapus Projects ini?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(backgroundColor: Colors.grey.shade100),
          child: MyText(title: 'Batal'),
        ),
        TextButton(
          onPressed: () {
            context.read<ProjectsBloc>().add(DeleteDataProjects(id: id));
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(backgroundColor: Colors.red),
          child: MyText(title: 'Ya, Yakin', color: Colors.white),
        ),
      ],
    ),
  );
}

Color bgcolors(String state) {
  switch (state.toLowerCase()) {
    case "pending":
      return Colors.orange.shade100;
    case "on going":
      return Colors.blue.shade100;
    case "completed":
      return Colors.green.shade100;
    case "cancelled":
      return Colors.red.shade100;
    default:
      return Colors.grey.shade100;
  }
}

Color colors(String state) {
  switch (state.toLowerCase()) {
    case "pending":
      return Colors.orange.shade700;
    case "on going":
      return Colors.blue.shade700;
    case "completed":
      return Colors.green.shade700;
    case "cancelled":
      return Colors.red;
    default:
      return Colors.grey.shade100;
  }
}
