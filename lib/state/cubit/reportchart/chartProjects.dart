import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/state/bloc/projets/projects_bloc.dart';

class ProjectsStatus {
  String status;
  int value;
  ProjectsStatus({required this.status, required this.value});
}

class ProjectsHightValue {
  String agenda;
  int value;
  ProjectsHightValue({required this.agenda, required this.value});
}

class ChartProjectsStaus extends Cubit<List<ProjectsStatus>> {
  ChartProjectsStaus() : super([]);
  void getProjectsData(ProjectsSuccesState state) {
    Map<String, int> projectsStatus = {};
    for (var data in state.list) {
      var status = data.status;
      projectsStatus[status] = (projectsStatus[status] ?? 0) + 1;
    }
    print(projectsStatus);
    final datachart = projectsStatus.entries.map((e) {
      return ProjectsStatus(status: e.key, value: e.value);
    }).toList();
    emit(datachart);
  }
}

class ChartProjectsHightValue extends Cubit<List<ProjectsHightValue>> {
  ChartProjectsHightValue() : super([]);
  void getProjectsData(ProjectsSuccesState state) {
    Map<String, int> projectsValue = {};
    var heighestData = [...state.list]
      ..sort((a, b) => a.price.compareTo(b.price));
    for (var i in heighestData) {
      projectsValue["${i.client!.name}-${i.agenda}"] = i.price;
    }
    final data =  projectsValue.entries.map((e){
      return ProjectsHightValue(
        agenda: e.key,
        value: e.value,
      );
    }).toList();
    emit(data.take(5).toList());
    print('HIGHTS VALUE PROJECTS ${projectsValue}');
  }
}
