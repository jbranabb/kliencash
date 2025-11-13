import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/clientPage/add_client.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/add_projects.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';
import 'package:intl/intl.dart';
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: MyText(
          title: 'Projects Client',
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: RefreshIndicator(onRefresh: () async {
        context.read<ProjectsBloc>().add(ReadDataProjects());
      }, child: CustomScrollView(
        slivers: [
          BlocConsumer<ProjectsBloc, ProjectsState>(
            listener: (context, state) {
            },
            builder: (context, state) {
              if(state is ProjectsSuccesState){
              if(state.list.isEmpty){
                return SliverToBoxAdapter(
                  child: Column(
                    children: [
                      MyText(title: 'Mana 19 projects nya')
                    ],
                  ),
                );
              }
              return SliverList.builder(
                itemCount: state.list.length,
                itemBuilder:(context, index) {
                  var list =  state.list[index];
                var startDate =  DateFormat('yyyy').parse(list.startAt);
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 0.3
                        )
                      )
                    ),
                    child: ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle
                        ),
                        child: Icon(Icons.work, color:Theme.of(context).colorScheme.onPrimary,),
                      ),
                      trailing: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: bgcolors(list.status),
                            borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: MyText(title: list.status,
                              fontSize: 10,
                               color: colors(list.status), fontWeight: FontWeight.w600,),
                            ),
                          ),
                          MyText(title: startDate.toString(), fontSize: 10,),
                          // MyText(title: list.endAt,  fontSize: 10,),
                        ],
                      ),
                      title: MyText(title: list.agenda, fontSize: 12,),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(title: list.client!.name,
                          fontSize: 12,
                           color: Colors.grey,fontWeight: FontWeight.w600, ),
                          MyText(title: list.desc,
                          fontSize: 12,
                           color: Colors.grey,),
                          MyText(title: "Rp ${list.price}",
                          fontSize: 12,
                           color: Colors.grey,),
                        ],
                      ),
                    ),
                  );
                  });
              }
              return SliverToBoxAdapter(child: Container());
            },
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddProjects(),));
      }, 
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      child: Icon(Icons.add, color: Colors.white,),),
    );
  }
}

Color bgcolors(String state){
  switch(state.toLowerCase()){
    case "pending":
    return Colors.orange.shade100;
    case "on going":
    return Colors.blue.shade100;
    case "completed":
    return Colors.green.shade100;
    case "cancelled":
    return Colors.red.shade100;
  default:
  return Colors.grey.shade100;
  }
}
Color colors(String state){
  switch(state.toLowerCase()){
    case "pending":
    return Colors.orange.shade700;
    case "on going":
    return Colors.blue.shade700;
    case "completed":
    return Colors.green.shade700;
    case "cancelled":
    return Colors.red;
  default:
  return Colors.grey.shade100;
  }
}