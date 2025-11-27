import 'package:bloc/bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:meta/meta.dart';
import 'package:kliencash/data/model/model.dart';
part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    var database = DatabaseHelper.instance;
    on<ReadDataPayment>((event, emit) async {
      var db = await database.getDatabase;
      var data = await db.rawQuery('''
      SELECT PAYMENT.*,
      PROJECTS.Id as id_projects,
      PROJECTS.agenda as projects_agenda,
      PROJECTS.desc as projects_desc,
      PROJECTS.status as projects_status,
      PROJECTS.client_id as projects_client_id,
      PROJECTS.estimatedValue as projects_price,
      PROJECTS.startAt as projects_startAt,
      PROJECTS.endAt as projects_endAt,
      PROJECTS.createdAt as projects_createdAt,
      PAYMENT_METHOD.id as pm_id,
      PAYMENT_METHOD.name as pm_name,
      PAYMENT_METHOD.type as pm_type,
      PAYMENT_METHOD.number as pm_number,
      PAYMENT_METHOD.account_name as pm_accountName,
      PAYMENT_METHOD.isActive as pm_isActive,
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
      INVOICE.createdAt as invoicee_createdAt,
      CLIENT.Id as id_client,
      CLIENT.name as client_name,
      CLIENT.handphone as client_phone,
      CLIENT.country_code as client_cc,
      CLIENT.alamat as client_alamat
      FROM PAYMENT
      INNER JOIN INVOICE ON INVOICE.Id = PAYMENT.invoice_id
      INNER JOIN PROJECTS ON PROJECTS.Id = INVOICE.project_id
      INNER JOIN CLIENT ON CLIENT.Id =  PROJECTS.client_id
      INNER JOIN PAYMENT_METHOD ON PAYMENT_METHOD.id = PAYMENT.payment_method_id
      ''');
      var results = data.map((e) => PaymentModel.fromJson(e)).toList();
      emit(PaymentReadDataSucces(list: results));
    });
    on<PostDataPayment>((event, emit) async {
      var db = await database.getDatabase;
      await db.insert('PAYMENT', event.paymentModel.toJson());
      emit(PaymentPostDataSucces());
    });
  }
}
