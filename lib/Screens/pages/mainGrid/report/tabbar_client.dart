import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:kliencash/state/cubit/reportchart/chartdataclientCubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TabbarClient extends StatelessWidget {
  TabbarClient({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: BlocBuilder<ChartDataClientCubit, List<ClientMonthlyData>>(
                  builder: (context, state) {
                    return SfCartesianChart(
                      title: ChartTitle(text: 'New Clients Monthly'),
                      primaryXAxis: CategoryAxis(
                        majorGridLines: const MajorGridLines(),
                      ),
                      primaryYAxis: NumericAxis(
                        majorGridLines: MajorGridLines(
                          width: 0.3,
                          color: Colors.grey[50],
                        ),
                        minimum: 0,
                      ),
                      series: [
                        LineSeries<ClientMonthlyData, String>(
                          color: Theme.of(context).colorScheme.onPrimary,
                          dataSource: state,
                          xValueMapper: (data, _) => data.month,
                          yValueMapper: (data, _) => data.count,
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                            height: 8,
                            width: 8,
                          ),

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
            SizedBox(
              child: BlocBuilder<ClientBloc, ClientState>(
                builder: (context, state) {
                  if (state is ClientSucces) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.list.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var client = state.list[index];
                        String initials = client.name.trim().isEmpty
                            ? '?'
                            : client.name.trim().length == 1
                            ? client.name[0].toUpperCase()
                            : client.name.trim().split(' ').length > 1
                            ? '${client.name.trim().split(' ')[0][0]}${client.name.trim().split(' ')[1][0]}'
                                  .toUpperCase()
                            : client.name[0].toUpperCase();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Avatar
                                  Container(
                                    height: 46,
                                    width: 46,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: MyText(
                                        title: initials,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  // Client Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          title: client.name,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              size: 12,
                                              color: Colors.grey[600],
                                            ),
                                            SizedBox(width: 6),
                                            Expanded(
                                              child: MyText(
                                                title:
                                                    "${client.countryCode} ${client.handphone}",
                                                fontSize: 12,
                                                color: Colors.grey[600]!,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 12,
                                              color: Colors.grey[600],
                                            ),
                                            SizedBox(width: 6),
                                            Expanded(
                                              child: MyText(
                                                title: client.alamat,
                                                fontSize: 13,
                                                color: Colors.grey[600]!,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  MyText(
                                    title: formatDateDetail(client.createdAt),
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

