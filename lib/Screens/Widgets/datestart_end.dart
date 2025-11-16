import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/add_projects.dart';
import 'package:kliencash/state/cubit/SelectedDateCubit.dart';
import 'package:intl/intl.dart';
class DateStartAndEnd extends StatelessWidget {
    DateStartAndEnd({super.key, required this.listener, this.title});
  void Function(BuildContext context, List<DateTime> state) listener;
  String? title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(title: title ?? 'Tanggal Mulai Dan Selesai'),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => showDateTime(context),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocConsumer<Selecteddatecubit, List<DateTime>>(
                      listener: listener,
                      builder: (context, state) {
                        if (state.length > 1) {
                          var startDate = DateFormat(
                            "dd-MM-yyyy",
                          ).format(state[0]);
                          var endDate = DateFormat(
                            "dd-MM yyyy",
                          ).format(state[1]);
                          return Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.calendar_month, color: Colors.grey),
                              MyText(
                                title: startDate,
                                fontWeight: FontWeight.w600,
                              ),
                              MyText(title: 'Sd'),
                              MyText(
                                title: endDate,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          );
                        }
                        return Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.calendar_month, color: Colors.grey),
                            MyText(title: 'Pilih Tanggal'),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
