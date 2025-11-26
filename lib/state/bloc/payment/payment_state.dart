part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}
final class PaymentLoading extends PaymentState {}
final class PaymentReadDataSucces extends PaymentState {
  List<PaymentModel> list;
  PaymentReadDataSucces({required this.list});
}
final class PaymentPostDataSucces extends PaymentState {}
