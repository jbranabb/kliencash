
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/cubit/checkbook_pembulatan.dart';
import 'package:kliencash/state/cubit/count_amount.dart';
import 'package:kliencash/state/cubit/drop_down_rounded.dart';

class CheckboxPembulatan extends StatelessWidget {
  const CheckboxPembulatan({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocBuilder<CheckbookPembulatan, bool>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: state,
                  onChanged: (value) {
                    context.read<CountMount>().setIsRounded(
                      !state,
                    );
                    context
                        .read<CheckbookPembulatan>()
                        .toggleCheckBox();
                  },
                ),
                MyText(title: LocaleKeys.rounding.tr(), fontSize: 12),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: AnimatedContainer(
                duration: Durations.medium3,
                height: state ? height * 0.06 : 0,
                width: width * 0.21,
    
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: BlocBuilder<DropDownRounded, String>(
                  builder: (context, stateTtile) {
                    List<String> list = ['1000', '500', '100'];
                    return DropdownButton<String>(
                      onChanged: (value) {
                        print('value on change $value');
                        context
                            .read<DropDownRounded>()
                            .setDropDown(value!);
                        context.read<CountMount>().setValueRouned(
                          int.parse(value),
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
                        child: MyText(
                          title: stateTtile,
                          color: state
                              ? Colors.black
                              : Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
