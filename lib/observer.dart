import 'package:flutter_bloc/flutter_bloc.dart';

class Observer extends BlocObserver{
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(bloc);
    print(transition);
    super.onTransition(bloc, transition);
  }
}