import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/Screens/pages/mainGrid/clientPage/add_client.dart';
import 'package:kliencash/state/bloc/client_bloc.dart';
import 'package:kliencash/state/cubit/statusProjectrs.dart';

class AddProjects extends StatefulWidget {
  const AddProjects({super.key});
  @override
  State<AddProjects> createState() => _AddProjectsState();
}

class _AddProjectsState extends State<AddProjects> {
  var agendaC = TextEditingController();
  var agendaF = FocusNode();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Container(
              width: width * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: BoxBorder.all(width: 1.4, color: Colors.grey.shade300),
              ),
              child: ListTile(
                title: MyText(title: 'Pilih Client'),
                leading: Icon(Icons.person, color: Colors.grey),
                trailing: Icon(Icons.arrow_drop_down, color: Colors.grey),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Container(
                      height: height * 0.8,
                      decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12))
                      ),
                      child: userstoAdd(context, height),
                    ),
                  );
                },
              ),
            ),
            MyTextFileds(
              controller: agendaC,
              label: "Agenda",
              icon: Icons.work,
              focusNode: agendaF,
            ),
            MyTextFileds(
              controller: agendaC,
              label: "Deskripsi",
              icon: Icons.description,
              focusNode: agendaF,
            ),
            MyTextFileds(
              controller: agendaC,
              label: "Harga Awal",
              icon: Icons.attach_money_outlined,
              focusNode: agendaF,
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
          ],
        ),
      ),
    );
  }
}

Widget userstoAdd(BuildContext context, double height) {
  return BlocBuilder<ClientBloc, ClientState>(
    builder: (context, state) {
      if (state is ClientSucces) {
        return SizedBox(
          height: height * 0.8,
          child: Column(
            children: [
              SizedBox(height: 20,
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
                        onTap: (){
                          print('object');
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
                            child: MyText(title: list.name.characters.first,
                             color: Theme.of(context).colorScheme.onPrimary,fontSize: 25,
                             fontWeight: FontWeight.bold,
                             ),
                          ),
                          title: MyText(title: list.name),
                          subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(title: "${list.countryCode} ${list.handphone}", color: Colors.grey,),
                            MyText(title: list.alamat, color: Colors.grey,),
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
