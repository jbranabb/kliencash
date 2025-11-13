part of 'projects_bloc.dart';

@immutable
sealed class ProjectsState {}

final class ProjectsInitial extends ProjectsState {}
final class ProjectsLoadingState extends ProjectsState {}
final class ProjectsSuccesState extends ProjectsState {
  List<ProjectsModel> list;
  ProjectsSuccesState({required this.list});
}
final class ProjectsErrorState extends ProjectsState {}
final class ProjectsPostSuccesState extends ProjectsState {}
final class ProjectsEditSuccesState extends ProjectsState {}
final class ProjectsDeleteSuccesState extends ProjectsState {}
