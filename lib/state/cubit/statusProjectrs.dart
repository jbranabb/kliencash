import 'package:flutter_bloc/flutter_bloc.dart';

class StatusprojectrsCubit extends Cubit<String?> {
  StatusprojectrsCubit() : super('');
  void setStatus(String? value){
    print(value);
    emit(value);
  }
}