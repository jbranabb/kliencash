import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/bloc/users/users_bloc.dart';

class ProfileData extends StatelessWidget {
  const ProfileData({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
                BlocBuilder<UsersBloc, UsersState>(
                  builder: (context, state) {
                    if (state is UsersSucces) {
                    var data = state.list[0];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            title: 'Hallo, ${data.username}',
                            color: Colors.grey,
                          ),
                          MyText(
                            title: data.namaPerusahaaan,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          Container(
                            width: width * 0.6,
                            child: MyText(
                              title: data.alamat,
                              color: Colors.grey,
                            ),
                          ),
                          MyText(
                            title: '${data.countryCode} ${data.phoneNumber}',
                            color: Colors.grey,
                          ),
                          MyText(
                            title: data.emaiil,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
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
