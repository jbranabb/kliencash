part of 'projects_bloc.dart';

@immutable
sealed class ProjectsEvent {}
class ReadDataProjects extends ProjectsEvent{}
class PostDataProjects extends ProjectsEvent{
  ProjectsModel projectsModel;
  PostDataProjects({required this.projectsModel});
}
class EditDataProjects extends ProjectsEvent{
  ProjectsModel projectsModel;
  int id;
  EditDataProjects({required this.projectsModel, required this.id});
}
class DeleteDataProjects extends ProjectsEvent{
  int id; 
  DeleteDataProjects({required this.id});
}
class ToggleIsExpandedProjects extends ProjectsEvent{
  int id; 
  ToggleIsExpandedProjects({required this.id});
}
class SearchProjects extends ProjectsEvent{
  String agenda; 
  SearchProjects({required this.agenda});
}