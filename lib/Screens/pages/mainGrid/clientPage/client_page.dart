import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/Screens/pages/mainGrid/clientPage/add_client.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kliencash/state/cubit/countryCode.dart';

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

  var name = TextEditingController();
  var phone = TextEditingController();
  var alamat = TextEditingController();

  var nameF = FocusNode();
  var phoneF = FocusNode();
  var alamatF = FocusNode();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: myAppBar(context,"All Client"),
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
                  Navigator.of(context).pop();
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
                  if (state.list.isEmpty) {
                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: height * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off,
                              size: 40,
                              color: Colors.grey,
                            ),
                            MyText(
                              title:
                                  "Tidak ada Clients Saat ini silahkan\ntambah client baru",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
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
                                  showDialog(
                                    context: context,
                                    builder: (context) => confrimDelete(
                                      list.name,
                                      context,
                                      list.id!,
                                    ),
                                  );
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: InkWell(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => editDataClient(
                                  list.id!,
                                  name,
                                  list.name,
                                  phone,
                                  list.handphone,
                                  alamat,
                                  list.alamat,
                                  list.countryCode,
                                  nameF,
                                  phoneF,
                                  alamatF,
                                  context,
                                ),
                              );
                            },
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
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

AlertDialog confrimDelete(String name, BuildContext context, int id) {
  return AlertDialog(
    title: MyText(title: 'Hapus Client $name?'),
    content: MyText(title: 'Apakah kamu yakin ingin hapus Client ini?'),
    actions: [
      TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.grey.shade100),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: MyText(title: 'Batal'),
      ),
      TextButton(
        onPressed: () {
          context.read<ClientBloc>().add(DeleteDataClient(id: id));
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(backgroundColor: Colors.red),
        child: MyText(title: 'Ya, Yakin', color: Colors.white),
      ),
    ],
  );
}

Dialog editDataClient(
  int id,
  TextEditingController name,
  String nameB,
  TextEditingController phone,
  String phoneB,
  TextEditingController alamat,
  String alamtB,
  String ccb,
  FocusNode nameF,
  FocusNode phoneF,
  FocusNode alamatF,
  BuildContext context,
) {
  name.text = nameB;
  phone.text = phoneB;
  alamat.text = alamtB;
  return Dialog(
    insetPadding: EdgeInsets.symmetric(horizontal: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: MyText(title: 'Edit data Client', fontSize: 18),
            ),
            MyTextFileds(
              controller: name,
              label: "Nama",
              icon: Icons.person,
              focusNode: nameF,
              isOtional: false,
              onEditingCom: () {
                FocusScope.of(context).requestFocus(phoneF);
              },
            ),
            MyTextFiledsForPhone(
              controller: phone,
              label: 'Phone',
              icon: Icons.phone,
              focusNode: phoneF,
              onEditingCom: () {
                FocusScope.of(context).requestFocus(alamatF);
              },
            ),
            MyTextFileds(
              controller: alamat,
              label: "Alamat",
              icon: Icons.home,
              focusNode: alamatF,
              isOtional: false,
              onEditingCom: () {
                var state = context.read<CountrycodeCubit>().state;
                if (nameB == name.text &&
                    phone.text == phoneB &&
                    alamat.text == alamtB &&
                    ccb == state) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    mySnakcbar(
                      'Tidak Ada Yang Berubah',
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                } else {
                  validateEdit(
                    id,
                    name.text,
                    state,
                    phone.text,
                    alamat.text,
                    context,
                  );
                }
              },
            ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: MyText(title: 'Batal'),
                ),
                BlocBuilder<CountrycodeCubit, String>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (nameB == name.text &&
                            phone.text == phoneB &&
                            alamat.text == alamtB &&
                            ccb == state) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            mySnakcbar(
                              'Tidak Ada Yang Berubah',
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          );
                        } else {
                          validateEdit(
                            id,
                            name.text,
                            state,
                            phone.text,
                            alamat.text,
                            context,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                      child: MyText(
                        title: "Selesai",
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void validateEdit(
  int id,
  String name,
  String countryCode,
  String phone,
  String alamat,
  BuildContext context,
) {
  if (name.isNotEmpty && phone.isNotEmpty && alamat.isNotEmpty) {
    context.read<ClientBloc>().add(
      EditDataClient(
        id: id,
        clientModel: ClientModel(
          name: name,
          alamat: alamat,
          handphone: phone,
          countryCode: countryCode,
        ),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: MyText(title: 'Terjadi Kesalahan'),
        content: MyText(title: "Silahkan isi smua fileds terlebih dahulu"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(backgroundColor: Colors.grey.shade100),
            child: MyText(title: 'Ok'),
          ),
        ],
      ),
    );
  }
}
