part of 'client_bloc.dart';

@immutable
sealed class ClientState {}

final class ClientInitial extends ClientState {}
final class ClientLoading extends ClientState {}
final class ClientSucces extends ClientState {
  List<ClientModel> list;
  ClientSucces({required this.list});
}
final class PostClientSucces extends ClientState {}
final class EditClientSucces extends ClientState {}
final class DeleteClientSucces extends ClientState {}
final class ClientError extends ClientState {}
