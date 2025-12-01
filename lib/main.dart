import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kliencash/Screens/Widgets/picked_pict.dart';
import 'package:kliencash/Screens/pages/home.dart';
import 'package:kliencash/Screens/pages/intialpage/onBorading.dart';
import 'package:kliencash/observer.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';
import 'package:kliencash/state/bloc/operasional/operasional_bloc.dart';
import 'package:kliencash/state/bloc/payment/payment_bloc.dart';
import 'package:kliencash/state/bloc/paymentMethod/payment_method_bloc.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:kliencash/state/bloc/users/users_bloc.dart';
import 'package:kliencash/state/cubit/SelectDateAddPayement.dart';
import 'package:kliencash/state/cubit/SelectedClient.dart';
import 'package:kliencash/state/cubit/SelectedDateCubit.dart';
import 'package:kliencash/state/cubit/SettingsCubit.dart';
import 'package:kliencash/state/cubit/bookstatuslength_cubit.dart';
import 'package:kliencash/state/cubit/checkbook_pembulatan.dart';
import 'package:kliencash/state/cubit/count_amount.dart';
import 'package:kliencash/state/cubit/countryCode.dart';
import 'package:kliencash/state/cubit/drop_down_rounded.dart';
import 'package:kliencash/state/cubit/dropdown_statusinvoice.dart';
import 'package:kliencash/state/cubit/onBoardingCubit.dart';
import 'package:kliencash/state/cubit/reportchart/chartdataclientCubit.dart';
import 'package:kliencash/state/cubit/selectedInvoice.dart';
import 'package:kliencash/state/cubit/selectedProjects.dart';
import 'package:kliencash/state/cubit/selectedpaymentMethod.dart';
import 'package:kliencash/state/cubit/statusProjectrs.dart';
import 'package:kliencash/themeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences initialpref = await SharedPreferences.getInstance();
  pref = initialpref;
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Bloc.observer = Observer();
  int launchCount  = pref?.getInt('launchCount') ?? 0;
  await pref?.setInt('launchCount', launchCount + 1);
  print('launchCount :$launchCount');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ClientBloc()..add(ReadDataClient())),
        BlocProvider(create: (context) => CountrycodeCubit()),
        BlocProvider(create: (context) => StatusprojectrsCubit()),
        BlocProvider(create: (context) => Selectedclient()),
        BlocProvider(create: (context) => Selecteddatecubit()),
        BlocProvider(create: (context) => ProjectsBloc()..add(ReadDataProjects()),),
        BlocProvider(create: (context) => SelectedProjects()),
        BlocProvider(create: (context) => CountMount()),
        BlocProvider(create: (context) => CheckbookPembulatan()),
        BlocProvider(create: (context) => DropDownRounded()),
        BlocProvider(create: (context) => DropdownStatusinvoice()),
        BlocProvider(create: (context) => InvoiceBloc()..add(ReadInvoice())),
        BlocProvider(create: (context) => Selectedinvoice()),
        BlocProvider(create: (context) => OpenBahasaToggle()),
        BlocProvider(create: (context) => OpenThemeToggle()),
        BlocProvider(create: (context) => ChangeTheme()..initialze()),
        BlocProvider(create: (context) => Onboardingcubit()),
        BlocProvider(create: (context) => UsersBloc()..add(ReadDataUsers())),
        BlocProvider(create: (context) => TogglePaymentMethod()),
        BlocProvider(create: (context) => PaymentMethodBloc()..add(ReadPaymentMethod())),
        BlocProvider(create: (context) => SelectedPaymentMethod()),
        BlocProvider(create: (context) => BookstatuslengthCubit()..getlength()),
        BlocProvider(create: (context) => PickedPict()),
        BlocProvider(create: (context) => SelectDateAddPayement()),
        BlocProvider(create: (context) => PaymentBloc()),
        BlocProvider(create: (context) => OperasionalBloc()..add(ReadData())),
        BlocProvider(create: (context) => ChartDataClientCubit()),
      ],
      child: MainApp(launchcount: launchCount,),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key, required this.launchcount});
  int launchcount;
   @override
  Widget build(BuildContext context) {
    print(launchcount);
    return BlocBuilder<ChangeTheme, int>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state == 0
              ? normalTheme
              : state == 1
              ? bluetheme
              : pinkTheme,
          home: launchcount == 0 ? OnboradingPage() : HomePage(),
        );
      },
    );
  }
}
