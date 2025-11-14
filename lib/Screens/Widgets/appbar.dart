import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';

AppBar myAppBar(BuildContext context,String title){
  return AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: MyText(title: title, color: Colors.white, fontSize: 18),
      );
}