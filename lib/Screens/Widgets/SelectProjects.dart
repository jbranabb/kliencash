import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/add_projects.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:kliencash/state/cubit/selectedProjects.dart';

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
                return SizedBox(
                  width: double.maxFinite,
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
