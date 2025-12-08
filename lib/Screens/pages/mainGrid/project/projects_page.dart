import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kliencash/Screens/Widgets/search_widget.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/datestart_end.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
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
import 'package:kliencash/state/cubit/toggleSearchUniversal.dart';

var formatRupiah = NumberFormat.currency(
  decimalDigits: 0,
  locale: 'id_ID',
  symbol: 'Rp ',
);

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

  var nameSeacrhC = TextEditingController();
  var nameSeacrhF = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: myAppBar(
        context,
        LocaleKeys.allProjects.tr(),
        actions: [
          seachButtonFunction(context, () {
            context.read<Togglesearchuniversal>().toggleSearch();
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProjectsBloc>().add(ReadDataProjects());
        },
        color: Theme.of(context).colorScheme.onPrimary,
        child: SingleChildScrollView(
          child: BlocConsumer<Togglesearchuniversal, bool>(
            listener: (context, state) {
              if (state == false) {
                nameSeacrhC.clear();
                FocusScope.of(context).unfocus();
              } else {
                FocusScope.of(context).requestFocus(nameSeacrhF);
              }
            },
            builder: (context, isActiveSearch) {
              return BlocConsumer<ProjectsBloc, ProjectsState>(
                listener: (context, state) {
                  if (state is ProjectsDeleteSuccesState) {
                    context.read<ProjectsBloc>().add(ReadDataProjects());
                    ScaffoldMessenger.of(context).showSnackBar(
                      mySnakcbar(
                        LocaleKeys.successDeleteProject.tr(),
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    );
                  } else if (state is ProjectsEditSuccesState) {
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
                    if (state.list.isEmpty && !isActiveSearch) {
                      return _buildEmptyState();
                    }
                    return Column(
                      children: [
                        SizedBox(height: 12),
                        isActiveSearch
                            ? textFiledsForSearch(context, nameSeacrhC, nameSeacrhF, (value) {
                              context.read<ProjectsBloc>().add(SearchProjects(agenda: value.trim()));
                            },)
                            : SizedBox.shrink(),
                        if (isActiveSearch && state.list.isEmpty) ...[
                          SizedBox(height: 20),
                          MyText(title: LocaleKeys.emptyFilter.tr()),
                        ],
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16),
                          itemCount: state.list.length,
                          itemBuilder: (context, index) {
                            var project = state.list[index];
                            return _buildProjectCard(context, project, index);
                          },
                        ),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AddProjects()));
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(Icons.add, color: Colors.white),
        label: MyText(
          title: LocaleKeys.projects.tr(),
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline, color: Colors.grey[400], size: 80),
          SizedBox(height: 16),
          MyText(
            title: LocaleKeys.noProject.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700]!,
          ),
          SizedBox(height: 8),
          MyText(
            title: LocaleKeys.addProjectFirst.tr(),
            color: Colors.grey[500]!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    ProjectsModel project,
    int index,
  ) {
    final startDate = DateTime.parse(project.startAt);
    final endDate = DateTime.parse(project.endAt);
    final createdAt = DateTime.parse(project.createdAt);

    final formattedStart = DateFormat('dd MMM yyyy').format(startDate);
    final formattedEnd = DateFormat('dd MMM yyyy').format(endDate);
    final formattedCreated = DateFormat('dd MMM yyyy, HH:mm').format(createdAt);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        key: Key(index.toString()),
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) {
                validateDeleteProjects(project.agenda, project.id!, context);
              },
              icon: Icons.delete_outline,
              label: LocaleKeys.deleteClient.tr(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onLongPress: () {
                final formattedDateStart = DateTime.parse(project.startAt);
                final formattedDateEnd = DateTime.parse(project.endAt);
                context.read<Selectedclient>().selectedClient(project.clientId);
                context.read<Selecteddatecubit>().setDate([
                  formattedDateStart,
                  formattedDateEnd,
                ]);
                context.read<StatusprojectrsCubit>().setStatus(project.status);
                startAtC.text = formattedDateStart.toIso8601String();
                endAtC.text = formattedDateEnd.toIso8601String();
                clientIdC.text = project.clientId.toString();
                print('client id : $clientIdC');
                _showEditDialog(
                  context,
                  project,
                  agendaC..text = project.agenda,
                  agendaF,
                  descC..text = project.desc ?? '',
                  descF,
                  priceC..text = formatCurrency(project.price),
                  priceF,
                  clientIdC,
                  startAtC,
                  endAtC,
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                title: project.agenda,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  MyText(
                                    title: project.client!.name,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600]!,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: bgcolors(project.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: MyText(
                            title: project.status,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colors(project.status),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 16,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          SizedBox(width: 4),
                          MyText(
                            title: formatRupiah.format(project.price),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),

                    // Description
                    if (project.desc != null && project.desc!.isNotEmpty) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: MyText(
                                title: project.desc!,
                                fontSize: 13,
                                color: Colors.grey[700]!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 12),
                    Divider(height: 1, color: Colors.grey[200]),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateInfo(
                            LocaleKeys.start.tr(),
                            formattedStart,
                            Icons.play_circle_outline,
                            Colors.green,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildDateInfo(
                            LocaleKeys.done.tr(),
                            formattedEnd,
                            Icons.check_circle_outline,
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 12, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        MyText(
                          title: '${LocaleKeys.created.tr()} $formattedCreated',
                          fontSize: 11,
                          color: Colors.grey[500]!,
                        ),
                      ],
                    ),

                    // Long Press Hint
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 11,
                          color: Colors.grey[400],
                        ),
                        SizedBox(width: 4),
                        MyText(
                          title: LocaleKeys.holdToEdit.tr(),
                          fontSize: 10,
                          color: Colors.grey[400]!,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, String date, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              SizedBox(width: 4),
              MyText(
                title: label,
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: 2),
          MyText(
            title: date,
            fontSize: 11,
            color: Colors.grey[700]!,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    ProjectsModel project,
    TextEditingController agendaC,
    FocusNode agendaF,
    TextEditingController descC,
    FocusNode descF,
    TextEditingController priceC,
    FocusNode priceF,
    TextEditingController clientIdC,
    TextEditingController startAt,
    TextEditingController endAt,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        print('build showdialog edit projects');
        return editProjects(
          context,
          MediaQuery.of(context).size.height,
          agendaC,
          agendaF,
          descC,
          descF,
          priceC,
          priceF,
          clientIdC,
          startAtC,
          endAtC,
          project,
        );
      },
    );
  }
}

Widget editProjects(
  BuildContext context,
  double height,
  TextEditingController agendaC,
  FocusNode agendaF,
  TextEditingController descC,
  FocusNode descF,
  TextEditingController priceC,
  FocusNode priceF,
  TextEditingController clientIdC,
  TextEditingController startAt,
  TextEditingController endAt,
  ProjectsModel projectsModel,
) {
  print('build edit projects widets');
  return Dialog(
    insetPadding: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Container(
      constraints: BoxConstraints(maxHeight: height * 0.8),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      SizedBox(width: 8),
                      MyText(
                        title: LocaleKeys.editProject.tr(),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.grey),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SelectClientsWidget(
                listener: (_, state) {
                  clientIdC.text = state['Id'].toString();
                },
              ),
              SizedBox(height: 12),
              MyTextFileds(
                controller: agendaC,
                label: LocaleKeys.agenda.tr(),
                icon: Icons.work,
                focusNode: agendaF,
                isOtional: false,
                onEditingCom: () {
                  FocusScope.of(context).requestFocus(descF);
                },
              ),
              SizedBox(height: 12),
              MyTextFileds(
                controller: descC,
                label: LocaleKeys.description.tr(),
                icon: Icons.description,
                focusNode: descF,
                maxlines: 10,
                isOtional: true,
                onEditingCom: () {
                  FocusScope.of(context).requestFocus(priceF);
                },
              ),
              SizedBox(height: 12),
              MyTextFileds(
                controller: priceC,
                label: LocaleKeys.initialPrice.tr(),
                icon: Icons.attach_money,
                focusNode: priceF,
                textType: TextInputType.number,
                isOtional: false,
                onEditingCom: () {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  var formatedValue = formatCurrency(int.parse(priceC.text));
                  priceC.value = TextEditingValue(
                    text: formatedValue,
                    selection: TextSelection.collapsed(
                      offset: formatedValue.length,
                    ),
                  );
                },
              ),
              SizedBox(height: 12),
              DateStartAndEnd(
                listener: (context, state) {
                  startAt.text = state[0].toIso8601String();
                  endAt.text = state[1].toIso8601String();
                },
              ),
              SizedBox(height: 12),

              Statuswidget(),
              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    var stateStatus = context
                        .read<StatusprojectrsCubit>()
                        .state;
                    validateEditProjects(
                      context,
                      agendaC.text,
                      descC.text,
                      priceC.text,
                      clientIdC.text,
                      startAt.text,
                      endAt.text,
                      stateStatus ?? "",
                      projectsModel.id!,
                      projectsModel,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: MyText(
                    title: LocaleKeys.done.tr(),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

void validateEditProjects(
  BuildContext context,
  String agendaC,
  String? descC,
  String priceC,
  String clientIdC,
  String startAt,
  String endAt,
  String status,
  int id,
  ProjectsModel projectsModel,
) {
  if (agendaC == projectsModel.agenda &&
      descC == projectsModel.desc &&
      priceC == priceC.toString() &&
      startAt == projectsModel.startAt &&
      endAt == projectsModel.endAt &&
      status == projectsModel.status &&
      clientIdC == projectsModel.clientId.toString()) {
    ScaffoldMessenger.of(context).showSnackBar(
      mySnakcbar(
        LocaleKeys.nothingChanges.tr(),
        Theme.of(context).colorScheme.onPrimary,
      ),
    );
    Navigator.of(context).pop();
  } else if (agendaC.isNotEmpty &&
      priceC.isNotEmpty &&
      clientIdC.isNotEmpty &&
      startAt.isNotEmpty) {
    var subtotalFormated = priceC.replaceAll(RegExp(r'[Rp\s.]'), '');
    context.read<ProjectsBloc>().add(
      EditDataProjects(
        projectsModel: ProjectsModel(
          clientId: int.parse(clientIdC),
          agenda: agendaC,
          desc: descC,
          price: int.parse(subtotalFormated),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            MyText(title: LocaleKeys.warning.tr()),
          ],
        ),
        content: MyText(title: LocaleKeys.pleasFillRequired.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: MyText(
              title: LocaleKeys.understood.tr(),
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.delete_outline, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: MyText(
              title: LocaleKeys.deleteProject.tr(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: MyText(
        title: LocaleKeys.deleteClientConfirm.tr(namedArgs: {'name': title}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: MyText(
            title: LocaleKeys.cancel.tr(),
            color: Colors.grey[700]!,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ProjectsBloc>().add(DeleteDataProjects(id: id));
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: MyText(
            title: LocaleKeys.yesDelete.tr(),
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
