import 'package:flutter_bloc/flutter_bloc.dart';

class Onboardingcubit extends Cubit<int> {
  Onboardingcubit() : super(0);
  void getPage(int value){
    emit(value);
  }
}