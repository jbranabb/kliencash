import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/data/model/client_model.dart';
import 'package:kliencash/state/bloc/client_bloc.dart';
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: MyText(
          title: "Add Client",
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<CountrycodeCubit, String>(
          builder: (context, state) {
            return Column(
              spacing: 10,
              children: [
                MyTextFileds(
                  controller: nameC,
                  icon: Icons.person,
                  label: "Nama",
                  focusNode: nameF,
                  onEditingCom: () {
                    FocusScope.of(context).requestFocus(phoneF);
                  },
                ),
                MyTextFiledsForPhone(
                  controller: phoneC,
                  label: "Phone",
                  icon: Icons.phone,
                  focusNode: phoneF,
                  onEditingCom: () {
                    FocusScope.of(context).requestFocus(alamatF);
                  },
                ),
                MyTextFileds(
                  controller: alamatC,
                  icon: Icons.home,
                  label: "Alamat",
                  focusNode: alamatF,
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
    );
  }
}

class MyTextFileds extends StatelessWidget {
  MyTextFileds({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.focusNode,
    this.onEditingCom,
  });
  TextEditingController controller;
  IconData icon;
  String label;
  FocusNode focusNode;
  void Function()? onEditingCom;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onEditingComplete: onEditingCom,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        enabled: true,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixText: "*",
        suffixStyle: TextStyle(color: Colors.red),
        label: MyText(title: label),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}

class MyTextFiledsForPhone extends StatelessWidget {
  MyTextFiledsForPhone({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.focusNode,
    this.onEditingCom,
  });
  TextEditingController controller;
  IconData icon;
  String label;
  FocusNode focusNode;
  void Function()? onEditingCom;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onEditingComplete: onEditingCom,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        enabled: true,
        icon: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: BoxBorder.all(color: Colors.grey.shade300, width: 1.5),
          ),
          child: CountryCodePicker(
            initialSelection: "ID",
            onInit: (value) {
              context.read<CountrycodeCubit>().changeCountryCode(
                value.toString(),
              );
            },
            onChanged: (value) {
              context.read<CountrycodeCubit>().changeCountryCode(
                value.toString(),
              );
            },
          ),
        ),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixText: "*",
        suffixStyle: TextStyle(color: Colors.red),
        label: MyText(title: label),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        border: OutlineInputBorder(),
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

SnackBar mySnakcbar(String title, Color? color) {
  return SnackBar(
    content: MyText(title: title, color: Colors.white),
    duration: Durations.long2,
    backgroundColor: color ?? Colors.red,
  );
}
