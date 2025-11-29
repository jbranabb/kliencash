part of 'operasional_bloc.dart';

@immutable
sealed class OperasionalState {}

final class OperasionalInitial extends OperasionalState {}
final class OperasionalLoading extends OperasionalState {}
final class OperasionalReadSucces extends OperasionalState {
  List<OperasionalModdel> list;
  OperasionalReadSucces({required this.list});
}
final class OperasionalPostSucces extends OperasionalState {}
final class OperasionalEditSucces extends OperasionalState {}
final class OperasionalDeleteSucces extends OperasionalState {}
