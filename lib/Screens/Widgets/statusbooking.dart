import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/myText.dart';

class BookingStatues extends StatelessWidget {
  const BookingStatues({super.key});

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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(title: cardData[index]['title'],
                        color: cardData[index]['color'] as Color,
                        ),
                        MyText(title: cardData[index]['value'], 
                        fontWeight: FontWeight.bold, 
                        color: cardData[index]['color'] as Color,
                        ),
                      ],
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

final List<Map<String, dynamic>> cardData = [
  {
    'title': 'Active Clients',
    'value': '24',
    'icon': Icons.people_outline,
    'color': Colors.blue,
  },
  {
    'title': 'DP - Partial',
    'value': '18',
    'icon': Icons.check_circle_outline,
    'color': Colors.orange,
  },
  {
    'title': 'Payments Done',
    'value': '3',
    'icon': Icons.pending_actions,
    'color': Colors.green,
  },
  {
    'title': 'Outsanding',
    'value': '4',
    'icon': Icons.payments,
    'color': Colors.red,
  },
];
