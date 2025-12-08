part of 'inovice_bloc.dart';

@immutable
sealed class InoviceEvent {}
class ReadInvoice extends InoviceEvent{}
class ReadInvoiceWithId extends InoviceEvent{
  int id;
  ReadInvoiceWithId({required this.id});
}
class PostInvoice extends InoviceEvent{
  InvoiceModel invoiceModel;
  PostInvoice({required this.invoiceModel});
}
class SearchInvoice extends InoviceEvent{
  String value;
  SearchInvoice({required this.value});
}
class SearchInvoiceWithId extends InoviceEvent{
  String value;
  SearchInvoiceWithId({required this.value});
}