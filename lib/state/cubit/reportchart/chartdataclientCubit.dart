import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';

class ClientMonthlyData {
  final String month;
  final int count;
  ClientMonthlyData(this.month, this.count);
}

class ChartDataClientCubit extends Cubit<List<ClientMonthlyData>> {
  ChartDataClientCubit() : super([]);
  void getDataChart(ClientSucces clientstate) {
    Map<String, int> monthly = {};
    const List<String> monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    for (var data in clientstate.list) {
      var date = DateTime.parse(data.createdAt);
      var key = "${date.year}-${date.month}";
      monthly[key] = (monthly[key] ?? 0) + 1;
    }
    final datachart = monthly.entries.map((e) {
      final parts = e.key.split("-");
      final monthNum = int.parse(parts[1]);
      return ClientMonthlyData(monthNames[monthNum -1], e.value);
    }).toList();
    emit(datachart);
    
  }
}
