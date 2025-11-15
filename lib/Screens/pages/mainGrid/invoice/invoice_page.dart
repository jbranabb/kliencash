import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/invoice/add_inovice.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, 'Invoice List'),
      body: RefreshIndicator( onRefresh: ()async{}, child: Column(),),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  AddInovice(),));
      },
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyText(title: '+', color: Colors.white, fontWeight: FontWeight.bold,),
          Icon(Icons.receipt_long_outlined, color: Colors.white,),
        ],
      ),),
    );
  }
}