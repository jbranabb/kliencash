import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:kliencash/state/cubit/countryCode.dart';

class AddClient extends StatefulWidget {
  const AddClient({super.key});

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  var nameC = TextEditingController();
  var nameF = FocusNode();
  var phoneC = TextEditingController();
  var phoneF = FocusNode();
  var alamatC = TextEditingController();
  var alamatF = FocusNode();

  @override
  void dispose() {
    nameC.dispose();
    phoneC.dispose();
    alamatC.dispose();
    nameF.dispose();
    phoneF.dispose();
    alamatF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context,"Add Client"),
      body: SingleChildScrollView(
        child: BlocListener<ClientBloc, ClientState>(
          listener: (context, state) {
            if (state is PostClientSucces) {
              Navigator.of(context).pop();
              context.read<ClientBloc>().add(ReadDataClient());
              ScaffoldMessenger.of(context).showSnackBar(
                mySnakcbar(
                  'Berhasil Menambahkan Client baru',
                  Theme.of(context).colorScheme.onPrimary,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<CountrycodeCubit, String>(
              builder: (context, state) {
                return Column(
                  spacing: 10,
                  children: [
                    Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(title: 'Nama Client', color: Colors.grey,),
                        MyTextFileds(
                          controller: nameC,
                          icon: Icons.person,
                          label: "Nama",
                          focusNode: nameF,
                          isOtional: false,
                          onEditingCom: () {
                            FocusScope.of(context).requestFocus(phoneF);
                          },
                        ),
                      ],
                    ),
                    Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(title: 'Phone Number', color: Colors.grey,),
                        MyTextFiledsForPhone(
                          controller: phoneC,
                          label: "Phone",
                          icon: Icons.phone,
                          focusNode: phoneF,
                          onEditingCom: () {
                            FocusScope.of(context).requestFocus(alamatF);
                          },
                        ),
                      ],
                    ),
                    Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(title: 'Alamat Client', color: Colors.grey,),
                        MyTextFileds(
                          controller: alamatC,
                          icon: Icons.home,
                          label: "Alamat",
                          focusNode: alamatF,
                          isOtional: false,
                          maxlines: 10,
                          onEditingCom: () {
                            validatePost(
                              nameC.text,
                              state,
                              phoneC.text,
                              alamatC.text,
                              context,
                            );
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        validatePost(
                          nameC.text,
                          state,
                          phoneC.text,
                          alamatC.text,
                          context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: MyText(
                        title: 'Selesai',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


void validatePost(
  String name,
  String countryCode,
  String phone,
  String alamat,
  BuildContext context,
) {
  if (name.isNotEmpty && phone.isNotEmpty && alamat.isNotEmpty) {
    context.read<ClientBloc>().add(
      PostDataClient(
        clientModel: ClientModel(
          name: name,
          alamat: alamat,
          handphone: phone,
          countryCode: countryCode,
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      mySnakcbar("Silahkan isi smua fileds terlebih dahulu", Colors.red),
    );
  }
}

