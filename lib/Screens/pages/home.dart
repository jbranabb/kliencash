import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/mainGrid.dart';
import 'package:kliencash/Screens/Widgets/myText.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var height =  MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blue.shade800,
            title: MyText(title: "Client Cash", 
            fontSize: 20,color: Colors.white, fontWeight: FontWeight.w600,),
          ),
          mainGrid()
        ],
      ),
    );
  }
}

