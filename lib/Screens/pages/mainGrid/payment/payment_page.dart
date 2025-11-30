import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/colors_status.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/payment/add_payment.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/payment/payment_bloc.dart';

class PayementPage extends StatefulWidget {
  const PayementPage({super.key});

  @override
  State<PayementPage> createState() => _PayementPageState();
}

class _PayementPageState extends State<PayementPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(ReadDataPayment());
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: myAppBar(context, 'Payment Page'),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentReadDataSucces) {
            if (state.list.isEmpty) {
              return SizedBox(
                height: height,
                width: double.maxFinite,
                child: Column(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.attach_money, size: 60,color: Colors.grey,),
                  MyText(title: 'Belum Ada Payment Saat Ini', fontWeight: FontWeight.bold,color: Colors.grey.shade700,),
                  MyText(title: 'Silahkan tambahkan Terlebih Dahulu',
                  color: Colors.grey,
                   textAlign: TextAlign.center,),
                ],
              ));
            }
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                var data = state.list[index];
                return _buildList(context, data);
              },
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddPayment()));
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(Icons.add, color: Colors.white),
        label: MyText(
          title: 'Payment',
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Widget _buildList(BuildContext context, PaymentModel data) {
  var height = MediaQuery.of(context).size.height;
  var pictHeight = height * 0.15;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 2,
                      children: [
                        Icon(Icons.receipt, size: 14),
                        MyText(
                          title: data.invoicemodel!.invoiceNumber,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            data.invoicemodel!.status.toLowerCase() == 'lunas'
                            ? Colors.blue.shade100
                            : Colors.orange.shade100,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: MyText(
                          title: data.invoicemodel!.status.toUpperCase(),
                          fontSize: 12,
                          color:
                              data.invoicemodel!.status.toLowerCase() == 'lunas'
                              ? Colors.blue
                              : Colors.orange.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.grey.shade100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        title: data.invoicemodel!.title,
                        fontWeight: FontWeight.bold,
                      ),
                      MyText(title: formatCurrency(data.amount)),
                      Column(
                        children: [
                      _buildRow(
                        Icon(Icons.work, color: Colors.grey, size: 14),
                        Expanded(
                          child: MyText(
                            title: data.projectsModel!.agenda,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      _buildRow(
                        Icon(Icons.person, color: Colors.grey, size: 14),
                        Expanded(child: MyText(title: data.clientModel!.name, color: Colors.grey)),
                      ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex:1,
                  child: InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (context) => Dialog(
                        child: Image.file(
                          File(data.buktiPayment),),
                      ),);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(12),
                      child: Image.file(
                        File(data.buktiPayment),
                        height: pictHeight,
                        width: pictHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 4,
              children: [
                Icon(Icons.calendar_month, color: Colors.grey, size: 14),
                MyText(
                  title: formatDateDetail(data.tanggalBayar),
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildRow(Widget w1, Widget w2) {
  return Row(spacing: 2, children: [w1, w2]);
}
