import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/mainGrid/add_client.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/bloc/client_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  @override
  void initState() {
    super.initState();
    print('init');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(title: 'Client Side', fontSize: 20, color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        onRefresh: () async {
          context.read<ClientBloc>().add(ReadDataClient());
        },
        child: CustomScrollView(
          slivers: [
            BlocConsumer<ClientBloc, ClientState>(
              listener: (context, state) {
                if (state is DeleteClientSucces) {
                  context.read<ClientBloc>().add(ReadDataClient());
                  ScaffoldMessenger.of(context).showSnackBar(
                    mySnakcbar(
                      'Berhasil Menghapus Client',
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                } else if (state is EditClientSucces) {
                  context.read<ClientBloc>().add(ReadDataClient());
                  ScaffoldMessenger.of(context).showSnackBar(
                    mySnakcbar(
                      'Berhasil Edit Data Client',
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ClientSucces) {
                  return SliverList.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      var list = state.list[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Slidable(
                          key: Key(index.toString()),
                          enabled: true,
                          endActionPane: ActionPane(
                            motion: DrawerMotion(),
                            extentRatio: 0.2,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  confrimDelete(list.name, context, list.id!);
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                alignment: Alignment.center,
                                child: MyText(
                                  title: list.name.characters.first,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              title: MyText(title: list.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    title:
                                        "${list.countryCode} ${list.handphone}",
                                    color: Colors.grey,
                                  ),
                                  MyText(
                                    title: list.alamat,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ClientLoading) {
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        MyText(title: "Tunngu Sebentar..."),
                      ],
                    ),
                  );
                }
                return SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddClient()));
        },
        child: Icon(Icons.person_add_alt_1_sharp, color: Colors.white),
      ),
    );
  }
}
AlertDialog confrimDelete(String name, BuildContext context, int id){
  return AlertDialog(
    title: MyText(title: 'Hapus Client $name'),
    content: MyText(title: 'Apakah kamu yakin ingin hapus Client ini?'),
    actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop();
      }, child: MyText(title: 'Batal')),
      TextButton(onPressed: (){
        context.read<ClientBloc>().add(DeleteDataClient(id: id));
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.red
      ),
       child: MyText(title: 'Ya, Yakin')),
    ],
  );
}