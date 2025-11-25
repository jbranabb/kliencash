part of 'inovice_bloc.dart';

@immutable
sealed class InvoiceState {}

final class InoviceInitial extends InvoiceState {}
final class InoviceLoading extends InvoiceState {}
final class InvoiceReadSucces extends InvoiceState {
  List<InvoiceModel> list;
  InvoiceReadSucces({required this.list});
}
final class InvoiceReadSuccesWithId extends InvoiceState {
  List<InvoiceModel> list;
  InvoiceReadSuccesWithId({required this.list});
}
final class InvoicePostSucces extends InvoiceState {}
