import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/profile_data.dart';
import 'package:kliencash/Screens/Widgets/main_grid.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/statusbooking.dart';
import 'package:kliencash/Screens/pages/settings.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:kliencash/state/cubit/bookstatuslength_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<BookstatuslengthCubit>().getlength();
    context.read<ClientBloc>().add(ReadDataClient());
    context.read<ProjectsBloc>().add(ReadDataProjects());
    context.read<InvoiceBloc>().add(ReadInvoice());
    print('INIT HOME');
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD HOME');
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            title: MyText(
              title: "Client Cash",
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            actions: [
              InkWell(
                borderRadius: BorderRadius.circular(120),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.settings, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
          ProfileData(),
          mainGrid(),
          BookingStatues(),
          SliverList(
            delegate: SliverChildBuilderDelegate(childCount: 10, (
              context,
              index,
            ) {
              return ListTile(title: MyText(title: 'title $index'));
            }),
          ),
        ],
      ),
    );
  }
}
