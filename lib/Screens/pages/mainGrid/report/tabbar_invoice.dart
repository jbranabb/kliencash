import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';
import 'package:kliencash/state/cubit/reportchart/chartinvoice.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TabbarInvoice extends StatelessWidget {
  const TabbarInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<InvoiceBloc, InvoiceState>(
                    builder: (context, state) {
                      if(state is InvoiceReadSucces){
                        var totalinvoice = 0 ; 
                        for(var i in state.list){
                          totalinvoice += i.totalAmount;
                        } 
                        var dppartial =  state.list.where((e)=> e.status.toLowerCase() != 'lunas');
                        var  dppartialtotal = 0;
                        for(var total in dppartial){
                          dppartialtotal += total.totalAmount;
                        }
                        return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyText(title: 'Summary Overall', fontWeight: FontWeight.w600,),
                          SizedBox(height: 10,),
                          _buildRow(
                            Icons.receipt_long_rounded,
                            'Total Invoice',
                            state.list.length.toString(),
                          ),
                          _buildRow(
                            Icons.payment_rounded,
                            'Total Paid',
                            formatCurrency(totalinvoice),
                          ),
                          _buildRow(
                            Icons.schedule_rounded,
                            'Dp / Partial (${dppartial.length})',
                            formatCurrency(dppartialtotal),
                          ),
                        ],
                      );
                      }
                      return SizedBox.shrink(); 
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: BlocBuilder<ChartinvoiceStatus, List<Invoicestatus>>(
                builder: (context, state) {
                  if (state.isEmpty) {
                    return SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 8,
                        children: [
                          SizedBox(height: 16),
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 40,
                            color: Colors.grey,
                          ),
                          MyText(
                            title: 'Tidak Ada Data Chart',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          MyText(
                            title:
                                'Belum Ada Invoie Saat Ini\nSilahkan Tambahkan Terlebih Dahulu',
                            textAlign: TextAlign.center,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    );
                  }
                  return SfCircularChart(
                    title: ChartTitle(text: 'Most Invoice Status'),
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      overflowMode: LegendItemOverflowMode.wrap,
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: [
                      DoughnutSeries<Invoicestatus, String>(
                        dataSource: state,
                        xValueMapper: (data, _) => data.status,
                        yValueMapper: (data, _) => data.value,
                        enableTooltip: true,
                        pointColorMapper: (data, index) {
                          switch (data.status.toLowerCase()) {
                            case 'lunas':
                              return Colors.blue;
                            case 'dp / partial':
                              return Colors.orange;
                            case 'completed':
                              return Colors.green;
                            case 'cancelled':
                              return Colors.red;
                            default:
                              return Colors.black;
                          }
                        },
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildRow(IconData icon, String title1, String title2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        spacing: 4,
        children: [
          Icon(icon, size: 16,),
          MyText(title: title1),
        ],
      ),
      MyText(title: title2),
    ],
  );
  
}
