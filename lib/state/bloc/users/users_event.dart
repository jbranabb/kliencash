part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class ReadDataUsers extends UsersEvent {}
class PostDataUsers extends UsersEvent {
User user;
PostDataUsers({required this.user});
}
class EditDataUsers extends UsersEvent {}
