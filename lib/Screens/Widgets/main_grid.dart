import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/pages/mainGrid/clientPage/client_page.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/invoice/invoice_page.dart';
import 'package:kliencash/Screens/pages/mainGrid/operasional/operasional_page.dart';
import 'package:kliencash/Screens/pages/mainGrid/payment/payment_page.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/projects_page.dart';
import 'package:kliencash/Screens/pages/mainGrid/report/report_page.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:kliencash/state/cubit/reportchart/chartdataclientCubit.dart';

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
        itemCount: 6,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (index == 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ClientPage(),
                    ),
                  );
                } else if (index == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProjectsPage(),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OperasionalPage(),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const InvoicePage(),
                    ),
                  );
                } else if (index == 4) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PayementPage(),
                    ),
                  );
                } else if (index == 5) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        context.read<ClientBloc>().add(ReadDataClient());
                        var state = context.read<ClientBloc>().state as ClientSucces;
                        context.read<ChartDataClientCubit>().getDataChart(state);
                        return ReportPage();
                      },
                    ),
                  );
                }
              },
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
                child: childGrid(index, context),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget childGrid(int index, BuildContext context) {
  switch (index) {
    case 0:
      return menuSection(context, Icons.person, 'Client');
    case 1:
      return menuSection(context, Icons.work, 'Projects');
    case 2:
      return menuSection(context, Icons.factory, 'Operasional');
    case 3:
      return menuSection(context, Icons.receipt_long_rounded, 'Invoice');
    case 4:
      return menuSection(context, Icons.attach_money, 'Payment');
    case 5:
      return menuSection(context, Icons.bar_chart_rounded, 'Report');
    default:
      return menuSection(context, Icons.person, 'Bowok');
  }
}

Widget menuSection(BuildContext context, IconData icon, String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(color: Theme.of(context).colorScheme.onPrimary, size: 30, icon),
      MyText(title: title),
    ],
  );
}
