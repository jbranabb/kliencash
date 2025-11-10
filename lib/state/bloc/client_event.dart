part of 'client_bloc.dart';

@immutable
sealed class ClientEvent {}

class ReadDataClient extends ClientEvent {}
class PostDataClient extends ClientEvent {
  ClientModel clientModel;
  PostDataClient({required this.clientModel});
}
class EditDataClient extends ClientEvent {
  ClientModel clientModel;
  EditDataClient({required this.clientModel});
}
class DeleteDataClient extends ClientEvent {
  int id; 
  DeleteDataClient({required this.id});
}
