import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/Screens/pages/home.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/paymentMethod/payment_method_bloc.dart';
import 'package:kliencash/state/bloc/users/users_bloc.dart';
import 'package:kliencash/state/cubit/bookstatuslength_cubit.dart';
import 'package:kliencash/state/cubit/countryCode.dart';

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
      body: BlocListener<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UsersPostSucces) {
            context.read<UsersBloc>().add(ReadDataUsers());
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          }
        },
        child: SingleChildScrollView(
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
                  maxlines: 10,
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
                    onPressed: () {
                      var state = context.read<CountrycodeCubit>().state;
                      _validatePost(
                        context,
                        usernameC.text,
                        namaPerusahaanC.text,
                        alamatC.text,
                        state,
                        phoneC.text,
                        emailC.text,
                      );
                    },
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
      ),
    );
  }
}

void _validatePost(
  BuildContext context,
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
    context.read<UsersBloc>().add(
      PostDataUsers(
        user: User(
          namaPerusahaaan: nameUsaha,
          username: username,
          alamat: alamat,
          emaiil: email,
          countryCode: countryCode,
          phoneNumber: int.parse(phoneNumber),
        ),
      ),
    );
    context.read<PaymentMethodBloc>().add(GenerateCashPaymentMethod());
    context.read<PaymentMethodBloc>().add(ReadPaymentMethod());
    context.read<BookstatuslengthCubit>().getlength();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      mySnakcbar('Silahkan isi semua fields terlebih dahulu', null),
    );
  }
}
