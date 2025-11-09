import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/myText.dart';

class ProfileData extends StatelessWidget {
  const ProfileData({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.2, 4),
                blurRadius: 10,
                color: Colors.grey.shade200,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(title: 'Hallo, Pingnie', color: Colors.grey),
                    MyText(
                      title: "Pinky Weeding",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    MyText(
                      title: 'Jalan Jendral Sudirmal, No.34',
                      color: Colors.grey,
                    ),
                    MyText(title: '+62 819-2920-2112', color: Colors.grey),
                    MyText(
                      title: 'contact@pinkywedding.com',
                      color: Colors.grey,
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.business,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
