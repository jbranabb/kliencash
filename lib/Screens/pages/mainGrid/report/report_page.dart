import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/report/tabbar_client.dart';
import 'package:kliencash/Screens/pages/mainGrid/report/tabbar_invoice.dart';
import 'package:kliencash/Screens/pages/mainGrid/report/tabbar_projects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var primary =  Theme.of(context).colorScheme.primary;
    var onPrimary =  Theme.of(context).colorScheme.onPrimary;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: myAppBar(context, 'Report Page'),
        body: Column(
          children: [
            SizedBox(height: height * 0.01,),
            ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: primary,
                ),
                height: 40,
                width: width * 0.90,
                child: TabBar(
                  dividerColor: Colors.transparent,
                  dividerHeight: 0,
                  splashBorderRadius: BorderRadius.circular(10),
                  unselectedLabelColor: onPrimary.withOpacity(0.5),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  labelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsetsGeometry.symmetric(
                    horizontal: 5,
                    vertical: 6,
                  ),
                  tabAlignment: TabAlignment.fill,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: onPrimary,
                  ),
                  tabs: const [
                    Text('Client'),
                    Text('Projects'),
                    Text('Invoice'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TabbarClient(),
                  TabbarProjects(),
                  TabbarInvoice()
                    ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
