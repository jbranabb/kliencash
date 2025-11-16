import 'package:flutter_bloc/flutter_bloc.dart';

class DropdownStatusinvoice  extends Cubit<String?>{
  DropdownStatusinvoice() : super('');
  void setStatus(String? text){
    emit(text);
  }
  void reset(){
    emit(null);
  }
}