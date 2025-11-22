import 'package:bloc/bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:meta/meta.dart';

part 'payment_method_event.dart';
part 'payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  PaymentMethodBloc() : super(PaymentMethodInitial()) {
    var database = DatabaseHelper.instance;
    on<ReadPaymentMethod>((event, emit) async {
      var db = await database.getDatabase;
      var data = await db.query('PAYMENT_METHOD');
      var results = data.map((e) => PaymentMethodModel.fromJson(e)).toList();
      emit(PaymentMethodSReaducces(list: results));
    });
    on<PostPaymentMethod>((event, emit) async {
      var db = await database.getDatabase;
      await db.insert('PAYMENT_METHOD', event.model.toJson());
      emit(PaymentMethodPostSucces());
    });
    on<EditPaymentMethod>((event, emit) async {
      var db = await database.getDatabase;
      await db.update(
        'PAYMENT_METHOD',
        event.model.toJson(),
        where: 'id = ?',
        whereArgs: [event.id],
      );
      emit(PaymentMethodEditSucces());
    });
    on<DeletePaymentMethod>((event, emit) async {
      var db = await database.getDatabase;
      await db.delete('PAYMENT_METHOD', where: 'id = ?', whereArgs: [event.id]);
      emit(PaymentMethodDeleteSucces());
    });
    on<GenerateCashPaymentMethod>((event, emit) async {
      var db = await database.getDatabase;
      await db.insert(
        'PAYMENT_METHOD',
        PaymentMethodModel(name: 'cash', type: "CASH", isActive: 0).toJson(),
      );
    });
  }
}
