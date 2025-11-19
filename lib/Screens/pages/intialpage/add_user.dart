import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var usernameC = TextEditingController();
  var usernameF = FocusNode();
  var namaPerusahaanC = TextEditingController();
  var namaPerusahaanF = FocusNode();
  var countryCodeC = TextEditingController();
  var phoneC = TextEditingController();
  var phoneF = FocusNode();
  var emailC = TextEditingController();
  var emailF = FocusNode();
  var alamatC = TextEditingController();
  var alamatF = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, 'Create User'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                spacing: 2,
                children: [
                  Icon(Icons.person, color: Colors.grey),
                  MyText(
                    color: Colors.grey,
                    title: 'User & Buisness Information',
                  ),
                ],
              ),
              MyTextFileds(
                controller: usernameC,
                label: "Username ",
                icon: Icons.person,
                focusNode: usernameF,
                isOtional: false,
                onEditingCom: () {
                  FocusScope.of(context).requestFocus(namaPerusahaanF);
                },
              ),
              MyTextFileds(
                controller: namaPerusahaanC,
                label: "Nama Usaha",
                icon: Icons.business,
                focusNode: namaPerusahaanF,
                isOtional: false,
                onEditingCom: () {
                  FocusScope.of(context).requestFocus(alamatF);
                },
              ),
              MyTextFileds(
                controller: alamatC,
                label: "Alamat",
                icon: Icons.home,
                focusNode: alamatF,
                isOtional: false,
                onEditingCom: () {
                  FocusScope.of(context).requestFocus(phoneF);
                },
              ),
              Row(
                spacing: 2,
                children: [
                  Icon(Icons.contacts_rounded, color: Colors.grey),
                  MyText(color: Colors.grey, title: 'Contacts Information'),
                ],
              ),
              MyTextFiledsForPhone(
                controller: phoneC,
                label: "Phonenumber",
                icon: Icons.phone,
                focusNode: phoneF,
                onEditingCom: () {
                  FocusScope.of(context).requestFocus(emailF);
                },
              ),
              MyTextFileds(
                controller: emailC,
                label: "Email",
                icon: Icons.email,
                focusNode: emailF,
                isOtional: false,
                onEditingCom: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: MyText(
                    title: 'Selesai',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _validatePost(
  String username,
  String nameUsaha,
  String alamat,
  String countryCode,
  String phoneNumber,
  String email,
) {
  if (username.isNotEmpty &&
      nameUsaha.isNotEmpty &&
      alamat.isNotEmpty &&
      countryCode.isNotEmpty &&
      phoneNumber.isNotEmpty &&
      email.isNotEmpty) {
      }else{

      }
}
