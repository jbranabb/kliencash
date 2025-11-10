part of 'client_bloc.dart';

@immutable
sealed class ClientEvent {}

class ReadDataClient extends ClientEvent {}
class PostDataClient extends ClientEvent {
  ClientModel clientModel;
  PostDataClient({required this.clientModel});
}
