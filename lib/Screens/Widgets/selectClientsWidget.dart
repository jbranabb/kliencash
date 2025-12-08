import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/add_projects.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/state/cubit/SelectedClient.dart';

class SelectClientsWidget extends StatefulWidget {
  SelectClientsWidget({super.key, required this.listener});
  void Function(BuildContext, Map<String, dynamic>) listener;

  @override
  State<SelectClientsWidget> createState() => _SelectClientsWidgetState();
}

class _SelectClientsWidgetState extends State<SelectClientsWidget> {
  var nameSeacrhC = TextEditingController();
  var nameSeacrhF = FocusNode();
  @override
  void dispose() {
    nameSeacrhC.dispose();
    nameSeacrhF.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocConsumer<Selectedclient, Map<String, dynamic>>(
      listener: widget.listener,
      builder: (context, state) {
        var stateIsnotEmpty = state['name'] != null;
        var rawName = state['name'].toString().trim().split(' ');
        var displayedName = rawName.length == 1
            ? state['name'].toString().characters.first
            : "${rawName[0].characters.first}${rawName[1].characters.first}";
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
          child: ListTile(
            title: MyText(
              title: stateIsnotEmpty
                  ? state['name'].toString()
                  : LocaleKeys.selectClient.tr(),
            ),
            leading: stateIsnotEmpty
                ? Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary,
                          offset: Offset(-2, 2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: MyText(
                      title: displayedName.toUpperCase(),
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(Icons.person, color: Colors.grey),
            subtitle: stateIsnotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 2,
                        children: [
                          Icon(Icons.phone, size: 14, color:Colors.grey,),
                          MyText(
                            title: "${state['countryCode']} ${state['handphone']}",
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only( top: 3.0),
                            child: Icon(Icons.location_on_sharp, size: 14, color:Colors.grey,),
                          ),
                          Expanded(
                            child: MyText(
                              title: state['almat'].toString(),
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : null,
            trailing: Icon(Icons.arrow_drop_down, color: Colors.grey),
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
                  child: userstoAdd(context, height,width,nameSeacrhC, nameSeacrhF),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
