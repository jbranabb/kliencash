import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/locale_keys.dart';
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
          borderRadius: BorderRadius.circular(12),
          hint: BlocBuilder<StatusprojectrsCubit, String?>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: bgcolors(state ?? ''),
                    border: Border.all(
                      color: colors(state ?? '')
                    ),
                    borderRadius: BorderRadius.circular(12) 
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 4,left: 8,right: 8),
                    child: MyText(title: state ?? LocaleKeys.selectStatus.tr(),color: state != null ? colors(state) : Colors.grey, fontWeight: FontWeight.w600,),
                  )),
              );
            },
          ),
        );
      },
    );
  }
}

Color bgcolors(String state){
  switch(state.toLowerCase()){
    case "pending":
    return Colors.orange.shade100;
    case "on going":
    return Colors.blue.shade100;
    case "completed":
    return Colors.green.shade100;
    case "cancelled":
    return Colors.red.shade100;
    case "lunas":
    return Colors.blue.shade100;
  case "dp / partial":
    return Colors.orange.shade100;
  default:
  return Colors.grey.shade100;
  }
}
Color colors(String state){
  switch(state.toLowerCase()){
    case "pending":
    return Colors.orange.shade700;
    case "on going":
    return Colors.blue.shade700;
    case "completed":
    return Colors.green.shade700;
    case "cancelled":
    return Colors.red;
    case "lunas":
    return Colors.blue.shade700;
    case "dp / partial":
    return Colors.orange.shade700;
    default:
  return Colors.grey.shade500;
  }
}
class MyTextFileds extends StatelessWidget {
  MyTextFileds({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.focusNode,
    required this.isOtional,
    this.textType,
    this.onEditingCom,
    this.onChanged,
    this.suffix,
  this.maxlines
  ,this.hint
  });
  TextEditingController controller;
  IconData icon;
  String label;
  bool isOtional;
  FocusNode focusNode;
  int? maxlines;
  TextInputType? textType;
  Widget? suffix;
  Widget? hint;
  void Function()? onEditingCom;
  void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      minLines: 1,
      maxLines: maxlines ?? 1,
      onEditingComplete: onEditingCom,
      keyboardType: textType ?? TextInputType.text,
      inputFormatters:textType == TextInputType.number ? [
        FilteringTextInputFormatter.digitsOnly,
        // LengthLimitingTextInputFormatter(maxLength)
      ] : [],
      onChanged: onChanged,
      decoration: InputDecoration(
        hint: hint ,
        enabled: true,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffix: suffix ?? MyText(title: isOtional ? "" : "*", color: Colors.red),
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
            borderRadius: BorderRadius.circular(12),
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

class TextFiledsReadOnly extends StatelessWidget {
  TextFiledsReadOnly({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.onChanged
  });
  TextEditingController controller;
  IconData icon;
  String label;
  void Function(String value)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        enabled: true,
        prefixIcon: Icon(icon, color: Colors.grey),
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
