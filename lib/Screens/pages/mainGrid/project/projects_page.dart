import 'package:flutter/material.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/clientPage/add_client.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/add_projects.dart';

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
      body: RefreshIndicator(onRefresh: () async {}, child: CustomScrollView(
        slivers: [],
      )),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddProjects(),));
      }, 
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      child: Icon(Icons.add, color: Colors.white,),),
    );
  }
}
