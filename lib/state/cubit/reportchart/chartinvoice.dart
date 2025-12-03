import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';

class Invoicestatus {
  String status;
  int value;
  Invoicestatus({required this.status, required this.value});
}

class ChartinvoiceStatus extends Cubit<List<Invoicestatus>> {
  ChartinvoiceStatus() : super([]);
  void getstatus(InvoiceReadSucces state) {
    Map<String, int> statusCount = {};
    for (var data in state.list) {
      statusCount[data.status] = (statusCount[data.status] ?? 0) + 1;
    }
    var finaldata = statusCount.entries.map(
      (e) => Invoicestatus(status: e.key, value: e.value),
    ).toList();
    emit(finaldata);
  }
}
