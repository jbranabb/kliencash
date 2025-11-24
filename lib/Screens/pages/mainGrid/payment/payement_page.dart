import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/payment/add_payment.dart';

class PayementPage extends StatelessWidget {
  const PayementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, 'Payment Page'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPayment()));
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(Icons.add, color: Colors.white),
        label: MyText(title: 'Payment', color: Colors.white),
      ),
    );
  }
}
