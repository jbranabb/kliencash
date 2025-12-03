import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';

class OveralCubitAll extends Cubit<List<ClientModel>> {
  OveralCubitAll() : super([]);
  var database =  DatabaseHelper.instance;
  void getDataOverral()async{
    var db = await database.getDatabase;
    var data =  await db.rawQuery(''' 
    SELECT CLIENT.*,
    PROJECTS.Id as id_projects,
    PROJECTS.agenda as projects_agenda,
    PROJECTS.desc as projects_desc,
    PROJECTS.status as projects_status,
    PROJECTS.client_id as projects_client_id,
    PROJECTS.estimatedValue as projects_price,
    PROJECTS.startAt as projects_startAt,
    PROJECTS.endAt as projects_endAt,
    PROJECTS.createdAt as projects_createdAt,
    INVOICE.project_id as invoice_projects_id,
    INVOICE.payement_method_id as invoice_payment_method_id,
    INVOICE.status as invoice_status,
    INVOICE.subtotal as invoice_subtotal,
    INVOICE.title as invoice_title,
    INVOICE.total_amount as invoice_totalAmount,
    INVOICE.tanggal as invoice_tanggal,
    INVOICE.jatuh_tempo as invoice_jatuhTempo,
    INVOICE.isRounded as invoice_isRounded,
    INVOICE.invoice_number as Invoice_invoiceNumber,
    INVOICE.createdAt as invoicee_createdAt
    FROM CLIENT
    INNER JOIN INVOICE ON INVOICE.Id = PAYMENT.invoice_id
    INNER JOIN PROJECTS ON PROJECTS.Id = INVOICE.project_id
    ''');
    var results = data.map((e)=> ClientModel.fromJson(e)).toList();
    emit(results);
  }
}