part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}
class ReadDataPayment extends PaymentEvent {}
class PostDataPayment extends PaymentEvent {
  PaymentModel paymentModel;
  PostDataPayment({required this.paymentModel});
}
