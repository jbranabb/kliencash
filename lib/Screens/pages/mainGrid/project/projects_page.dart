import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/add_projects.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:intl/intl.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

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
                if(state is ProjectsDeleteSuccesState){
                  context.read<ProjectsBloc>().add(ReadDataProjects());
                  ScaffoldMessenger.of(context).showSnackBar(mySnakcbar("Berhasil Menghapu Projects", Theme.of(context).colorScheme.onPrimary));
                }
              },
              builder: (context, state) {
                if (state is ProjectsSuccesState) {
                  if (state.list.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(height: height * 0.18,),
                          Icon(Icons.cancel,color: Colors.grey,size: 60,),
                          MyText(title: 'Belum Ada Projects Saat Ini\n Silahkan Tambahkan Terlebih Dahulu',textAlign: TextAlign.center,)],
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
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 0.3),
                          ),
                        ),
                        child: Slidable(
                          key: Key(list.id!.toString()),
                          endActionPane: ActionPane(
                            motion: DrawerMotion(),
                            extentRatio: 0.22,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  validateDeleteProjects(list.agenda, list.id!, context);
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width * 0.6,
                                      child: MyText(
                                        title: list.agenda,
                                        fontSize: 12,
                                      ),
                                    ),
                                    MyText(
                                      title: list.client!.name,
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
                                    if (list.desc!.isNotEmpty) ...[
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
                                      title: "Cretaed At",
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
                                        borderRadius: BorderRadius.circular(8),
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
          child: MyText(title: 'Ya, Yakin', color: Colors.white,),
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
