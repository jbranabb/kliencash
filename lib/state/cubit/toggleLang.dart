import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

class Togglelang extends Cubit<String> {
  Togglelang() : super(''); 
  void initlangue(String lang){
    emit(lang); 
    print('state');
  }
  void nowlangue(String lang){
    emit(lang); 
    print('state');
  }
}