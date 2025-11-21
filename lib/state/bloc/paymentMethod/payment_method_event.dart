part of 'payment_method_bloc.dart';

@immutable
sealed class PaymentMethodEvent {}
class ReadPaymentMethod  extends PaymentMethodEvent {}
class PostPaymentMethod  extends PaymentMethodEvent {
  PaymentMethodModel model;
  PostPaymentMethod({required this.model});
}
class EditPaymentMethod  extends PaymentMethodEvent {
    PaymentMethodModel model;
    int id;
    EditPaymentMethod({required this.model, required this.id});
}
class DeletePaymentMethod  extends PaymentMethodEvent {
  int id;
  DeletePaymentMethod({required this.id});
}