import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';

class SelectedPaymentMethod extends Cubit<Map<String, dynamic>> {
  SelectedPaymentMethod() : super({});
  var database = DatabaseHelper.instance;
  void selectablePayment(int id) async {
    var db = await database.getDatabase;
    var data = await db.query('PAYMENT_METHOD', where: 'id = ?', whereArgs: [id]);
    var rawresults = data.map((e) => PaymentMethodModel.fromJson(e)).toList();
    var finalresults = rawresults[0];
    emit({
      "id":finalresults.id,
      "name":finalresults.name,
      "accountName":finalresults.accountName,
      "number":finalresults.number,
      "type":finalresults.type
    });
  }

  void reset(){
    emit({});
  }
}
