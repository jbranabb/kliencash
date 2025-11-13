part of 'projects_bloc.dart';

@immutable
sealed class ProjectsEvent {}
class ReadDataProjects extends ProjectsEvent{}
class PostDataProjects extends ProjectsEvent{
  ProjectsModel projectsModel;
  PostDataProjects({required this.projectsModel});
}
class EditDataProjects extends ProjectsEvent{}
class DeleteDataProjects extends ProjectsEvent{}