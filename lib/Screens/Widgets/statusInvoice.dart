
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/colors_status.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/state/cubit/dropdown_statusinvoice.dart';

class StatusInvoice extends StatelessWidget {
  const StatusInvoice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        BlocBuilder<DropdownStatusinvoice, String?>(
          builder: (context, stateTtile) {
            List<String> list = [LocaleKeys.dp.tr().toUpperCase(), LocaleKeys.fullyPaid.tr().toUpperCase(),LocaleKeys.installments.tr().toUpperCase() ];
            return DropdownButton<String>(
              onChanged: (value) {
                context.read<DropdownStatusinvoice>().setStatus(
                  value,
                );
              },
              items: list
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: MyText(title: value),
                    ),
                  )
                  .toList(),
              underline: Container(),
              borderRadius: BorderRadius.circular(12),
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: bgcolors(stateTtile ?? ''),
                    border: Border.all(
                      color: colors(stateTtile ?? ''),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 4,left: 8,right: 8),
                    child: MyText(title: stateTtile ?? LocaleKeys.selectStatus.tr(), color: colors(stateTtile ?? ''),),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}