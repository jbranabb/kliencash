part of 'inovice_bloc.dart';

@immutable
sealed class InoviceEvent {}
class ReadInvoice extends InoviceEvent{}
class PostInvoice extends InoviceEvent{
  InvoiceModel invoiceModel;
  PostInvoice({required this.invoiceModel});
}
