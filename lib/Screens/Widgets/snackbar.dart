import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';

SnackBar mySnakcbar(String title, Color? color) {
  return SnackBar(
    content: MyText(title: title, color: Colors.white),
    duration: Durations.extralong3,
    backgroundColor: color ?? Colors.red,
  );
}
