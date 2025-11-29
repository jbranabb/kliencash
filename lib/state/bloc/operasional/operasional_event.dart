part of 'operasional_bloc.dart';

@immutable
sealed class OperasionalEvent {}
class ReadData extends OperasionalEvent {}
class PostData extends OperasionalEvent {
  OperasionalModdel operasionalModdel;
  PostData({required this.operasionalModdel});
}
class EditData extends OperasionalEvent {
  int id;
  OperasionalModdel operasionalModdel;
  EditData({
    required this.id,
    required this.operasionalModdel});
}
class DeleteData extends OperasionalEvent {
  int id;
  DeleteData({
    required this.id,});
}
