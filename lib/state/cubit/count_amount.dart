import 'package:flutter_bloc/flutter_bloc.dart';

class CountMount extends Cubit<int> {
  int? subtotal;
  int? pajak;
  int? disc;
  bool? isRounded;
  int? roundedValue;
  CountMount() : super(0);

  void setSubtotal(int? s) {
    subtotal = s;
    _count();
  }

  void setpajak(int? p) {
    pajak = p;
    _count();
  }

  void setDisc(int? d) {
    disc = d;
    _count();
  }

  void setIsRounded(bool? itsRound) {
    isRounded = itsRound;
    _count();
    print('called $roundedValue');
    print('called $itsRound');
  }

  void setValueRouned(int? r) {
    roundedValue = r;
    _count();
    print('value $roundedValue');
  }

  void _count() {
    var sub = subtotal ?? 0;
    var pjk = pajak != null ? sub * (pajak! / 100) : 0;
    var discount = disc != null ? sub * (disc! / 100) : 0;
    var total = (sub + pjk - discount).toInt();
    if (isRounded == true) {
      var value = roundedValue ?? 0;
      if (value > 0) {
        var rounded = ((total / value).round()) * value;
        emit(rounded);
        print(rounded);
      }
    } else {
      emit(total);
    }
  }

  void reset() {
    pajak = 0;
    subtotal = 0;
    disc = 0;
    emit(0);
  }
}
