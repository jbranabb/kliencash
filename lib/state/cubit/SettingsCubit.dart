import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/main.dart';

class OpenBahasaToggle extends Cubit<bool> {
  OpenBahasaToggle() : super(false);
  void toggleBahasa() {
    emit(!state);
  }

  void reset() {
    emit(false);
  }
}

class OpenThemeToggle extends Cubit<bool> {
  OpenThemeToggle() : super(false);
  void toggleThm() {
    emit(!state);
  }

  void reset() {
    emit(false);
  }
}

class ChangeTheme extends Cubit<int> {
  ChangeTheme() : super(0);
  void initialze()async {
    var values = pref?.getInt('theme') ?? 0;
    emit(values);
  }
  void setTheme(int value) async {
    await pref?.setInt('theme', value);
    var values = pref?.getInt('theme') ?? 0;
    emit(values);
  }
}
