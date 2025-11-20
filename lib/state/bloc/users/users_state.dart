part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}
final class UsersLoading extends UsersState {}
final class UsersSucces extends UsersState {
  List<User> list;
  UsersSucces({required this.list});
}
final class UsersPostSucces extends UsersState {}
final class UsersEditSucces extends UsersState {}
