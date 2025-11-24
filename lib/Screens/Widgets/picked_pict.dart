import 'package:flutter_bloc/flutter_bloc.dart';

class PickedPict extends Cubit<String> {
  PickedPict() : super('');

  void getImage(String path){
    emit(path);
  }
}