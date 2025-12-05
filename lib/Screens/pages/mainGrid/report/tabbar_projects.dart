import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/cubit/reportchart/chartProjects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TabbarProjects extends StatelessWidget {
  const TabbarProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ClipRect(
                  child:
                      BlocBuilder<
                        ChartProjectsHightValue,
                        List<ProjectsHightValue>
                      >(
                        builder: (context, state) {
                          if (state.isEmpty) {
                            return SizedBox.shrink();
                          }
                          return SfCartesianChart(
                            title: ChartTitle(text: LocaleKeys.projectRanking.tr()),
                            primaryXAxis: CategoryAxis(),
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              builder:
                                  (
                                    data,
                                    point,
                                    series,
                                    pointIndex,
                                    seriesIndex,
                                  ) {
                                    var value = point.y != null
                                        ? point.y!.toInt()
                                        : 0;
                                    var nameValue = point.x;
                                    return Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "$nameValue: ${formatCurrency(value)}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  },
                            ),
                            series: [
                              BarSeries<ProjectsHightValue, String>(
                                color: Theme.of(context).colorScheme.onPrimary,
                                dataSource: state,
                                xValueMapper: (d, _) {
                                  var namevalue = d.agenda.split('-');
                                  var displayedName =
                                      namevalue[1].toString().length >= 10
                                      ? namevalue[0]
                                      : "${namevalue[0]}\n${namevalue[1]}";
                                  return displayedName;
                                },
                                yValueMapper: (d, _) => d.value,
                                dataLabelMapper: (d, _) {
                                  return formatCurrency(d.value);
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: BlocBuilder<ChartProjectsStaus, List<ProjectsStatus>>(
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
                            Icon(Icons.work, size: 40, color: Colors.grey),
                            MyText(
                              title: LocaleKeys.noChartData.tr(),
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            MyText(
                              title:
                                  LocaleKeys.noProjectsData.tr(),
                              textAlign: TextAlign.center,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      );
                    }
                    return SfCircularChart(
                      title: ChartTitle(text: LocaleKeys.projectStatus.tr()),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: [
                        DoughnutSeries<ProjectsStatus, String>(
                          dataSource: state,
                          xValueMapper: (data, _) => data.status,
                          yValueMapper: (data, _) => data.value,
                          enableTooltip: true,
                          pointColorMapper: (data, index) {
                            switch (data.status.toLowerCase()) {
                              case 'on going':
                                return Colors.blue;
                              case 'pending':
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
      ),
    );
  }
}
