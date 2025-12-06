import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/add_projects.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/state/bloc/operasional/operasional_bloc.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:kliencash/state/cubit/selectedProjects.dart';

var formatRupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

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
              var id = state['Id'];
              var price = state['estimatedValue'];
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
                            title: formatRupiah.format(state['estimatedValue']),
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                          BlocBuilder<OperasionalBloc, OperasionalState>(
                                    builder: (context, state) {
                                      if (state is OperasionalReadSucces) {
                                        var data = state.list
                                            .where((e) => e.projectId == id)
                                            .toList();
                                        if (data.isEmpty) {
                                          return MyText(
                                            title: 'Belum Ada Biaya Operasional',
                                            fontSize: 8,
                                            color: Colors.grey,
                                          );
                                        }
                                        var totalAmount = 0;
                                        for(var amount in data){
                                            totalAmount += amount.amount;
                                        }
                                        return Column(
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
                                                      crossAxisAlignment:CrossAxisAlignment.center,
                                                      children: [
                                                        MyText(
                                                          title: '• ',
                                                          fontWeight:FontWeight.bold,
                                                          fontSize: 8,
                                                          color: Colors.grey.shade700,
                                                        ),
                                                        MyText(
                                                          title:'${listOp.title} ',
                                                          fontWeight:FontWeight.w600,
                                                          fontSize: 8,
                                                          color: Colors.grey.shade700,
                                                        ),
                                                        MyText(
                                                          title: formatCurrency(
                                                            listOp.amount,
                                                          ),
                                                          fontSize: 8,
                                                          color: Colors.grey,
                                                          fontWeight:FontWeight.w600,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            MyText(
                                              title: 'Total: ${formatCurrency(totalAmount + price)}',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ],
                                        );
                                      }
                                      return Container();
                                    },
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

Widget projectsDate(
  String title,
  Color bgColor,
  Color color, {
  IconData? icon,
}) {
  return Container(
    decoration: BoxDecoration(
      // color: bgColor,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 2,
        children: [
          Icon(
            icon ?? Icons.play_circle_outline_rounded,
            size: 8,
            color: color,
          ),
          MyText(
            title: title,
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    ),
  );
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
                return SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.18),
                      Icon(Icons.cancel, color: Colors.grey, size: 60),
                      MyText(
                        title:
                            "${LocaleKeys.noProject.tr()}\n${LocaleKeys.addProjectFirst.tr()}",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Material(
                        color: Colors.transparent,
                        child: Card(
                          clipBehavior: Clip.none,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
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
                                  MyText(title: list.agenda, fontSize: 13, fontWeight: FontWeight.w600,),
                                  MyText(
                                    title: list.client!.name,
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  MyText(
                                    title: formatRupiah.format(list.price),
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  BlocBuilder<OperasionalBloc, OperasionalState>(
                                    builder: (context, state) {
                                      if (state is OperasionalReadSucces) {
                                        var data = state.list
                                            .where((e) => e.projectId == list.id)
                                            .toList();
                                        if (data.isEmpty) {
                                          return MyText(
                                            title: LocaleKeys.noOperationalCost.tr(),
                                            fontSize: 8,
                                            color: Colors.grey,
                                          );
                                        }
                                        var totalAmount = 0;
                                        for(var amount in data){
                                            totalAmount += amount.amount;
                                        }
                                        return Column(
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
                                                      crossAxisAlignment:CrossAxisAlignment.center,
                                                      children: [
                                                        MyText(
                                                          title: '• ',
                                                          fontWeight:FontWeight.bold,
                                                          fontSize: 8,
                                                          color: Colors.grey.shade700,
                                                        ),
                                                        MyText(
                                                          title:'${listOp.title} ',
                                                          fontWeight:FontWeight.w600,
                                                          fontSize: 8,
                                                          color: Colors.grey.shade700,
                                                        ),
                                                        MyText(
                                                          title: formatCurrency(
                                                            listOp.amount,
                                                          ),
                                                          fontSize: 8,
                                                          color: Colors.grey,
                                                          fontWeight:FontWeight.w600,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            MyText(
                                              title: 'Total: ${formatCurrency(totalAmount + list.price)}',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ],
                                        );
                                      }
                                      return Container();
                                    },
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
