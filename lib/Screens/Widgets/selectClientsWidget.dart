import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/add_projects.dart';
import 'package:kliencash/state/cubit/SelectedClient.dart';

class SelectClientsWidget extends StatelessWidget {
  SelectClientsWidget({super.key, required this.listener});
  void Function(BuildContext, Map<String, dynamic>) listener;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return BlocConsumer<Selectedclient, Map<String, dynamic>>(
      listener: listener,
      builder: (context, state) {
        var stateIsnotEmpty = state['name'] != null;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
          child: ListTile(
            title: MyText(
              title: stateIsnotEmpty ? state['name'] : 'Pilih Client',
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
                      title: state['name'].toString().characters.first,
                      color: Theme.of(context).colorScheme.onPrimary,
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
                        title: "${state['countryCode']} ${state['handphone']}",
                        color: Colors.grey,
                      ),
                      MyText(
                        title: state['almat'].toString(),
                        color: Colors.grey,
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
                  child: userstoAdd(context, height),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
