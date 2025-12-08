import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kliencash/Screens/Widgets/search_widget.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/colors_status.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart'
    hide colors, bgcolors;
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/operasional/operasional_bloc.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:kliencash/state/cubit/toggleSearchUniversal.dart';

class OperasionalPage extends StatefulWidget {
  const OperasionalPage({super.key});

  @override
  State<OperasionalPage> createState() => _OperasionalPageState();
}

class _OperasionalPageState extends State<OperasionalPage> {
  var titleC = TextEditingController();
  var titleF = FocusNode();
  var amountC = TextEditingController();
  var amountF = FocusNode();

  var nameSeacrhC = TextEditingController();
  var nameSeacrhF = FocusNode();

  @override
  void dispose() {
    titleC.dispose();
    titleF.dispose();
    amountC.dispose();
    amountF.dispose();
    nameSeacrhC.dispose();
    nameSeacrhF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        context,
        LocaleKeys.operasionalPage.tr(),
        actions: [
          seachButtonFunction(context, () {
            context.read<Togglesearchuniversal>().toggleSearch();
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocListener<OperasionalBloc, OperasionalState>(
          listener: (context, state) {
            if (state is OperasionalPostSucces) {
              context.read<OperasionalBloc>().add(ReadData());
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                mySnakcbar(
                  LocaleKeys.successAddModal.tr(),
                  Theme.of(context).colorScheme.onPrimary,
                ),
              );
              titleC.clear();
              amountC.clear();
            } else if (state is OperasionalEditSucces) {
              context.read<OperasionalBloc>().add(ReadData());
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                mySnakcbar(
                  LocaleKeys.successEditModal.tr(),
                  Theme.of(context).colorScheme.onPrimary,
                ),
              );
              titleC.clear();
              amountC.clear();
            } else if (state is OperasionalDeleteSucces) {
              context.read<OperasionalBloc>().add(ReadData());
              ScaffoldMessenger.of(context).showSnackBar(
                mySnakcbar(
                  LocaleKeys.successDeleteModal.tr(),
                  Theme.of(context).colorScheme.onPrimary,
                ),
              );
            }
          },
          child: BlocConsumer<Togglesearchuniversal, bool>(
            listener: (context, isActiveSearch) {
              if (isActiveSearch == false) {
                nameSeacrhC.clear();
                FocusScope.of(context).unfocus();
              } else {
                FocusScope.of(context).requestFocus(nameSeacrhF);
              }
            },
            builder: (context, isActiveSearch) {
              return BlocBuilder<ProjectsBloc, ProjectsState>(
                builder: (context, state) {
                  if (state is ProjectsSuccesState) {
                    if (state.list.isEmpty && !isActiveSearch) {
                      return SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.work, size: 60, color: Colors.grey),
                            MyText(
                              title: LocaleKeys.noProjects.tr(),
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                            MyText(
                              title: LocaleKeys.addOperasionalFirst.tr(),
                              color: Colors.grey,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
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
                          itemCount: state.list.length,
                          itemBuilder: (context, index) {
                            var data = state.list[index];
                            var isExpanded = data.isExpanded;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(top: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(-2, 2),
                                      color: Colors.grey.shade300,
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: ClipRect(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        context.read<ProjectsBloc>().add(
                                          ToggleIsExpandedProjects(id: index),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          spacing: 4,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                MyText(
                                                  title: data.agenda,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: bgcolors(
                                                      data.status,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: MyText(
                                                      title: data.status
                                                          .toUpperCase(),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10,
                                                      color: colors(
                                                        data.status,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            _buildRow(
                                              Icons.person,
                                              data.client!.name,
                                              iconSize: 16,
                                              textSize: 14,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: _buildRow(
                                                  Icons.attach_money,
                                                  formatCurrency(data.price),
                                                  colors: Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary,
                                                  iconSize: 18,
                                                  textSize: 14,
                                                ),
                                              ),
                                            ),
                                            _buildRow(
                                              Icons.watch_later_outlined,
                                              '${LocaleKeys.created.tr()}: ${formatDateDetail(data.createdAt)}',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _buildRow(
                                                  Icons.touch_app,
                                                  "${LocaleKeys.clickToAdd.tr()} ${LocaleKeys.opeartional.tr()}",
                                                  textSize: 8,
                                                ),
                                                Icon(
                                                  isExpanded
                                                      ? Icons
                                                            .arrow_drop_up_rounded
                                                      : Icons
                                                            .arrow_drop_down_rounded,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AnimatedContainer(
                                                    height: isExpanded
                                                        ? null
                                                        : 0,
                                                    duration: Durations.long1,
                                                    child: Column(
                                                      children: [
                                                        operasionalList(
                                                          data,
                                                          context,
                                                          titleC,
                                                          titleF,
                                                          amountC,
                                                          amountF,
                                                        ),
                                                        SizedBox(height: 10),
                                                        addNewOperasionalButton(
                                                          context,
                                                          titleC,
                                                          titleF,
                                                          amountC,
                                                          amountF,
                                                          data,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
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
                  } else if (state is ProjectsLoadingState) {
                    return SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget addNewOperasionalButton(
  BuildContext context,
  TextEditingController titleC,
  FocusNode titleF,
  TextEditingController amountC,
  FocusNode amountF,
  ProjectsModel data,
) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      titleC.clear();
      amountC.clear();
      showDialog(
        context: context,
        builder: (context) => operasionalFunction(
          context,
          titleC,
          titleF,
          amountC,
          amountF,
          data,
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 2,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.grey),
            MyText(
              title: LocaleKeys.operasional.tr(),
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget operasionalList(
  ProjectsModel data,
  BuildContext context,
  TextEditingController titleC,
  FocusNode titleF,
  TextEditingController amountC,
  FocusNode amountF,
) {
  return SizedBox(
    child: BlocBuilder<OperasionalBloc, OperasionalState>(
      builder: (context, state) {
        if (state is OperasionalReadSucces && state.list.isNotEmpty) {
          var dataOp = state.list.where((e) => e.projectId == data.id).toList();
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: dataOp.length,
            itemBuilder: (context, index) {
              var list = dataOp[index];
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(data.id.toString()),
                confirmDismiss: (direction) {
                  return showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: MyText(title: LocaleKeys.deleteItem.tr()),
                      content: MyText(
                        title: LocaleKeys.deleteClientConfirm.tr(
                          namedArgs: {"name": list.title},
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: MyText(title: LocaleKeys.cancel.tr()),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            context.read<OperasionalBloc>().add(
                              DeleteData(id: list.id!),
                            );
                          },
                          child: MyText(
                            title: LocaleKeys.yesConfirm.tr(),
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onLongPress: () {
                        titleC.text = list.title;
                        amountC.text = list.amount.toString();
                        showDialog(
                          context: context,
                          builder: (context) => operasionalFunction(
                            context,
                            titleC,
                            titleF,
                            amountC,
                            amountF,
                            data,
                            title: LocaleKeys.edit.tr(),
                            onPressed: () {
                              if (titleC.text.isNotEmpty &&
                                  amountC.text.isNotEmpty) {
                                var cleaned = amountC.text.replaceAll(
                                  RegExp(r'[Rp\s.]'),
                                  '',
                                );
                                context.read<OperasionalBloc>().add(
                                  EditData(
                                    id: list.id!,
                                    operasionalModdel: OperasionalModdel(
                                      projectId: data.id!,
                                      title: titleC.text,
                                      amount: int.parse(cleaned),
                                      date: DateTime.now().toIso8601String(),
                                    ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: MyText(
                                      title: LocaleKeys.errorOccurred.tr(),
                                    ),
                                    content: MyText(
                                      title: LocaleKeys.fillFieldsFirst,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: MyText(
                                          title: LocaleKeys.ok.tr(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                      child: ListTile(
                        title: MyText(
                          title: list.title,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        subtitle: MyText(
                          title: formatCurrency(list.amount),
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        trailing: MyText(
                          title: formatDateDetail(list.date),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Container();
      },
    ),
  );
}

Widget operasionalFunction(
  BuildContext context,
  TextEditingController titleC,
  FocusNode titleF,
  TextEditingController amountC,
  FocusNode amountF,
  ProjectsModel data, {
  String? title,
  void Function()? onPressed,
}) {
  return Dialog(
    insetPadding: EdgeInsets.symmetric(horizontal: 8),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              title:
                  '${title ?? LocaleKeys.adding.tr()} ${LocaleKeys.opeartional.tr()}',
              fontWeight: FontWeight.w600,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.work, color: Colors.black),
                title: MyText(title: data.agenda, fontWeight: FontWeight.w600),
                subtitle: _buildRow(Icons.person, data.client!.name),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: bgcolors(data.status),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: MyText(
                      title: data.status.toUpperCase(),
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: colors(data.status),
                    ),
                  ),
                ),
              ),
            ),
            MyTextFileds(
              controller: titleC,
              label: LocaleKeys.title.tr(),
              icon: Icons.description,
              focusNode: titleF,
              isOtional: false,
              onEditingCom: () {
                FocusScope.of(context).requestFocus(amountF);
              },
            ),
            MyTextFileds(
              controller: amountC,
              label: LocaleKeys.amount.tr(),
              icon: Icons.attach_money,
              focusNode: amountF,
              isOtional: false,
              textType: TextInputType.number,
              onChanged: (value) {
                var formated = formatCurrency(int.parse(amountC.text));
                amountC.value = TextEditingValue(text: formated);
              },
              onEditingCom: () {
                FocusScope.of(context).unfocus();
              },
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed:
                    onPressed ??
                    () {
                      if (titleC.text.isNotEmpty && amountC.text.isNotEmpty) {
                        var cleaned = amountC.text.replaceAll(
                          RegExp(r'[Rp\s.]'),
                          '',
                        );
                        context.read<OperasionalBloc>().add(
                          PostData(
                            operasionalModdel: OperasionalModdel(
                              projectId: data.id!,
                              title: titleC.text,
                              amount: int.parse(cleaned),
                              date: DateTime.now().toIso8601String(),
                            ),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: MyText(title: LocaleKeys.error.tr()),
                            content: MyText(
                              title: LocaleKeys.fillFieldsFirst.tr(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: MyText(title: 'Ok'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: MyText(
                  title: LocaleKeys.done.tr(),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildRow(
  IconData icon,
  String title, {
  double? iconSize,
  double? textSize,
  Color? colors,
  FontWeight? fontWeight,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 4,
    children: [
      Icon(icon, color: colors ?? Colors.grey, size: iconSize ?? 14),
      MyText(
        title: title,
        color: colors ?? Colors.grey,
        fontSize: textSize ?? 12,
        fontWeight: fontWeight ?? FontWeight.bold,
      ),
    ],
  );
}
