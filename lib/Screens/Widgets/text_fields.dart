import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/cubit/countryCode.dart';
import 'package:kliencash/state/cubit/statusProjectrs.dart';

class TextFieldsDropDown extends StatelessWidget {
  TextFieldsDropDown({super.key});
  List<String> status = ['Pending', 'On Going', 'Completed', 'Cancelled'];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusprojectrsCubit, String?>(
      builder: (context, state) {
        return DropdownButton<String>(
          onChanged: (value) {
            context.read<StatusprojectrsCubit>().setStatus(value);
          },
          items: status
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: MyText(title: value),
                ),
              )
              .toList(),
          underline: Container(),
          hint: BlocBuilder<StatusprojectrsCubit, String?>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyText(title: state ?? 'Pilih Status',color: state != null ?Colors.black : Colors.grey, fontWeight: FontWeight.w600,),
              );
            },
          ),
        );
      },
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
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}