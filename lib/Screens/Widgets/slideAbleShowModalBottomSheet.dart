import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/search_widget.dart';
import 'package:kliencash/state/cubit/toggleSearchUniversal.dart';

Widget slideAbleModalBottomSheet(BuildContext context) {
  var symmetricHorizontal =  8.0;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      fakeSearchButton(context, padding: EdgeInsets.symmetric(horizontal: symmetricHorizontal)),
      SizedBox(
        height: 20,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 0.0,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ),
      seachButtonFunction(context, (){
        print('tapped');
        context.read<Togglesearchuniversal>().toggleSearch();
      },
      padding: EdgeInsets.symmetric(horizontal: symmetricHorizontal),
      colorWhenActive: Theme.of(context).colorScheme.onPrimary
      )
    ],
  );
}
