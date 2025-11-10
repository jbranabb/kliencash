import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountrycodeCubit extends Cubit<String>{
  CountrycodeCubit() : super("0");
  void changeCountryCode(String newCode){
    emit(newCode);
  }
}