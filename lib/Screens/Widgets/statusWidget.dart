import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';

class Statuswidget extends StatelessWidget {
  const Statuswidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                spacing: 10,
                children: [
                  MyText(title: LocaleKeys.status.tr() + ':'),
                  TextFieldsDropDown(),
                ],
              ),
            );
  }
}