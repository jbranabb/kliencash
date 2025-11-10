import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/data/model/client_model.dart';
import 'package:kliencash/state/bloc/client_bloc.dart';

SliverToBoxAdapter mainGrid() {
  return SliverToBoxAdapter(
    child: SizedBox(
      width: double.maxFinite,
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0.2, 4),
                  blurRadius: 10,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                context.read<ClientBloc>().add(ReadDataClient());
                if(index == 0){
                context.read<ClientBloc>().add(PostDataClient(clientModel: ClientModel(name: "jibran", alamat: "jalan Madura", handphone: "13131")));
                }
              },
              child: childGrid(index,context)),
          ),
        ),
      ),
    ),
  );
}

Widget childGrid(int index, BuildContext context) {
  switch (index) {
    case 1:
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.receipt_long_rounded),
        MyText(title: "Invoice")
      ],
    );
    case 2:
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.attach_money_rounded),
        MyText(title: "Payment")
      ],
    );
    case 3:
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.bar_chart_rounded),
        MyText(title: "Report")
      ],
    );
    default:
      return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.person),
        MyText(title: "Client")
      ],
    );
  }
}
