import 'package:flutter_bloc/flutter_bloc.dart';

class DropDownRounded extends Cubit<String> {
  DropDownRounded() : super('1000');
  void setDropDown(String drop){
    emit(drop);
  }
}