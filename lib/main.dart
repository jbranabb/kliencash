import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/pages/home.dart';
import 'package:kliencash/state/bloc/client_bloc.dart';
import 'package:kliencash/themeData.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => ClientBloc()..add(ReadDataClient())
      ,)
    ],
    child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: pinkTheme,
      home: HomePage()
    );
  }
}
