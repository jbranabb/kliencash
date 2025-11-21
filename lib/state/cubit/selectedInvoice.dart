import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';

class Selectedinvoice extends Cubit<List<InvoiceModel>> {
  Selectedinvoice() : super([]);
  var database = DatabaseHelper.instance;
  void getbyId(int id) async {
    var db = await database.getDatabase;
    var results = await db.rawQuery(
      '''
      SELECT INVOICE.*,
       PROJECTS.Id as id_projects,
       PROJECTS.agenda as projects_agenda,
       PROJECTS.desc as projects_desc,
       PROJECTS.status as projects_status,
       PROJECTS.client_id as projects_client_id,
       PROJECTS.estimatedValue as projects_price,
       PROJECTS.startAt as projects_startAt,
       PROJECTS.endAt as projects_endAt,
       PROJECTS.createdAt as projects_createdAt,
       CLIENT.Id as id_client,
       CLIENT.name as client_name,
       CLIENT.handphone as client_phone,
       CLIENT.country_code as client_cc,
       CLIENT.alamat as client_alamat,
       PAYMENT_METHOD.id as payementMethod_id,
       PAYMENT_METHOD.name as paymn_name,
       PAYMENT_METHOD.type as paymn_type,
       PAYMENT_METHOD.number as paymn_number,
       PAYMENT_METHOD.account_name as paymn_accountName,
       PAYMENT_METHOD.isActive as paymn_isActive
      FROM INVOICE
      INNER JOIN PROJECTS ON INVOICE.project_id = PROJECTS.id
      INNER JOIN CLIENT ON PROJECTS.client_id = CLIENT.Id
      INNER JOIN PAYMENT_METHOD ON INVOICE.payement_method_id = PAYMENT_METHOD.id   
      WHERE INVOICE.Id = ?
    ''',
      [id],
    );
    var data = results.map((e) => InvoiceModel.fromJson(e)).toList();
    emit(data);
    print(data[0]);
  }

  void reset() {
    emit([]);
  }
}
