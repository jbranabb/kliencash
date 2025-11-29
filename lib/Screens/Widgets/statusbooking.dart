import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:kliencash/state/cubit/bookstatuslength_cubit.dart';

class BookingStatues extends StatefulWidget {
  const BookingStatues({super.key});

  @override
  State<BookingStatues> createState() => _BookingStatuesState();
}

class _BookingStatuesState extends State<BookingStatues> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  title: 'Status',
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                mainAxisExtent: height * 0.1,
              ),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 10,
                        offset: Offset(0.2, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child:
                        BlocBuilder<
                          BookstatuslengthCubit,List<Map<String, dynamic>>>(
                          builder: (context, cardData) {
                            if(cardData.isEmpty){
                              return MyText(title: 'Loading...');
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  title:  cardData[index]['title'].toString(),
                                  color: cardData[index]['color'] as Color,
                                ),
                                MyText(
                                  title:  cardData[index]['value'].toString(),
                                  fontWeight: FontWeight.bold,
                                  color: cardData[index]['color'] as Color,
                                ),
                              ],
                            );
                          },
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
