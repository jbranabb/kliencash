import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/pages/home.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:kliencash/state/cubit/SelectedClient.dart';
import 'package:kliencash/state/cubit/SelectedDateCubit.dart';
import 'package:kliencash/state/cubit/checkbook_pembulatan.dart';
import 'package:kliencash/state/cubit/count_amount.dart';
import 'package:kliencash/state/cubit/countryCode.dart';
import 'package:kliencash/state/cubit/drop_down_rounded.dart';
import 'package:kliencash/state/cubit/dropdown_statusinvoice.dart';
import 'package:kliencash/state/cubit/selectedInvoice.dart';
import 'package:kliencash/state/cubit/selectedProjects.dart';
import 'package:kliencash/state/cubit/statusProjectrs.dart';
import 'package:kliencash/themeData.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => ClientBloc()..add(ReadDataClient()),),
      BlocProvider(create: (context) => CountrycodeCubit()),
      BlocProvider(create: (context) => StatusprojectrsCubit()),
    BlocProvider(create: (context) => Selectedclient()),
      BlocProvider(create: (context) => Selecteddatecubit()),
      BlocProvider(create: (context) => ProjectsBloc()..add(ReadDataProjects())),
      BlocProvider(create: (context) => SelectedProjects()),
      BlocProvider(create: (context) => CountMount()),
      BlocProvider(create: (context) => CheckbookPembulatan()),
      BlocProvider(create: (context) => DropDownRounded()),
      BlocProvider(create: (context) => DropdownStatusinvoice()),
      BlocProvider(create: (context) => InvoiceBloc()..add(ReadInvoice())),
      BlocProvider(create: (context) => Selectedinvoice()),
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
