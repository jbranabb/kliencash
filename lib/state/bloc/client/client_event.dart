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
  int id;
  EditDataClient({required this.clientModel, required this.id});
}
class DeleteDataClient extends ClientEvent {
  int id; 
  DeleteDataClient({required this.id});
}
class SeacrhClient extends ClientEvent {
  String name; 
  SeacrhClient({required this.name});
}
