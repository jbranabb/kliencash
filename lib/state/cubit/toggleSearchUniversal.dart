import 'package:flutter_bloc/flutter_bloc.dart';

class Togglesearchuniversal extends Cubit<bool> {
  Togglesearchuniversal() : super(false);
  void toggleSearch(){
    emit(!state);
  }
  void resetButton(){
    emit(false);
  }
}
