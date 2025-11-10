import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/bloc/client_bloc.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  @override
  void initState() {
    super.initState();
    print('init');
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: MyText(title: 'Client Side',
            fontSize: 20,
             color: Colors.white),
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          BlocBuilder<ClientBloc, ClientState>(
            builder: (context, state) {
              if (state is ClientSucces) {
                return SliverList.builder(
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    var list = state.list[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Card(
                        child: ListTile(
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            alignment: Alignment.center,
                            child: MyText(
                              title: list.name.characters.first,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          title: MyText(title: list.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                title: "${list.handphone}",
                                color: Colors.grey,
                              ),
                              MyText(title: list.alamat, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }else if(state is ClientLoading){
                SliverToBoxAdapter(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator( color: Theme.of(context).colorScheme.onPrimary,),
                  MyText(title: "Tunngu Sebentar...")
                  ],
                ),);
              }
              return SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}
