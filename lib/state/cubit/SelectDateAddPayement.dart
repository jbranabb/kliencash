import 'package:flutter_bloc/flutter_bloc.dart';

class SelectDateAddPayement extends Cubit<List<DateTime>> {
  SelectDateAddPayement() : super([]);
  void setDateTime(List<DateTime> date) {
    emit(date);
  }
  void reset()=> emit([]);
}
