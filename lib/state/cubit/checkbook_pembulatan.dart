import 'package:flutter_bloc/flutter_bloc.dart';

class CheckbookPembulatan extends Cubit<bool>{
  CheckbookPembulatan() : super(false);
  void toggleCheckBox(){
    emit(!state);
  }
}