import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/state/cubit/toggleSearchUniversal.dart';

Widget seachButtonFunction(context, void Function()? onTap, {Color? colorWhenActive, EdgeInsets? padding}) {
  var secondaryColor = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: padding ?? EdgeInsets.all(8.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(200),
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.all(8.0),
        child: BlocBuilder<Togglesearchuniversal, bool>(
          builder: (context, state) { 
            return Icon(
              Icons.search,
              color: state ? colorWhenActive ??Colors.white : secondaryColor,
            );
          },
        ),
      ),
    ),
  );
}
Widget fakeSearchButton(context, {EdgeInsets? padding}) {
  var secondaryColor = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: padding ?? EdgeInsets.all(8.0),
    child: Padding(
      padding: padding ?? EdgeInsets.all(8.0),
      child: BlocBuilder<Togglesearchuniversal, bool>(
        builder: (context, state) {
          return Icon(
            Icons.search,
            color:Colors.white ,
          );
        },
      ),
    ),
  );
}
