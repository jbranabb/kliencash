import 'package:flutter_bloc/flutter_bloc.dart';

class Selecteddatecubit extends Cubit<List<DateTime>> {
  Selecteddatecubit()
    : super([
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        DateTime.now().add(Duration(days: 7)),
      ]);
  void setDate(List<DateTime> list) {
    emit(list);
  }
}
