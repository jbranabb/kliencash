import 'package:bloc/bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:meta/meta.dart';

part 'inovice_event.dart';
part 'inovice_state.dart';

class InvoiceBloc extends Bloc<InoviceEvent, InvoiceState> {
  InvoiceBloc() : super(InoviceInitial()) {
    var database = DatabaseHelper.instance;
    on<ReadInvoice>((event, emit) async {
      var db = await database.getDatabase;
      var data = await db.rawQuery(''' 
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
       CLIENT.alamat as client_alamat
      FROM INVOICE
      INNER JOIN PROJECTS ON INVOICE.project_id = PROJECTS.id
      INNER JOIN CLIENT ON PROJECTS.client_id = CLIENT.Id  
      ''');
      List<InvoiceModel> results = data
          .map((e) => InvoiceModel.fromJson(e))
          .toList();
      emit(InvoiceReadSucces(list: results));
    });
    on<PostInvoice>((event, emit) async {
      var db = await database.getDatabase;
      await db.insert('INVOICE', event.invoiceModel.toJson());
      emit(InvoicePostSucces());
    });
  }
}
