part of 'payment_method_bloc.dart';

@immutable
sealed class PaymentMethodState {}

final class PaymentMethodInitial extends PaymentMethodState {}
final class PaymentMethodSReaducces extends PaymentMethodState {
  List<PaymentMethodModel> list;
  PaymentMethodSReaducces({required this.list});
}
final class PaymentMethodPostSucces extends PaymentMethodState {}
final class PaymentMethodEditSucces extends PaymentMethodState {}
final class PaymentMethodDeleteSucces extends PaymentMethodState {}
