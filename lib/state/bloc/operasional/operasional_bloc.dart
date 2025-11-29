import 'package:bloc/bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:meta/meta.dart';

part 'operasional_event.dart';
part 'operasional_state.dart';

class OperasionalBloc extends Bloc<OperasionalEvent, OperasionalState> {
  OperasionalBloc() : super(OperasionalInitial()) {
    var database = DatabaseHelper.instance;
    on<ReadData>((event, emit) async {
    var db = await database.getDatabase;
    var data = await db.rawQuery(''' 
    SELECT OPERASIONAL.*,
    PROJECTS.Id as projects_id,
    PROJECTS.agenda as projects_agenda,
    PROJECTS.desc as projects_desc,
    PROJECTS.status as projects_status,
    PROJECTS.client_id as projects_client_id,
    PROJECTS.estimatedValue as projects_price,
    PROJECTS.startAt as projects_startAt,
    PROJECTS.endAt as projects_endAt,
    PROJECTS.createdAt as projects_createdAt
    FROM OPERASIONAL 
    INNER JOIN PROJECTS ON OPERASIONAL.project_id = PROJECTS.Id
    ''');
    var results = data.map((e) => OperasionalModdel.fromJson(e)).toList();
    emit(OperasionalReadSucces(list:results));
    });
    on<PostData>((event, emit) async{
      var db = await database.getDatabase;
      db.insert('OPERASIONAL', event.operasionalModdel.toJson());
      emit(OperasionalPostSucces());
    });
    on<EditData>((event, emit) async{
      var db = await database.getDatabase;
      db.update('OPERASIONAL', event.operasionalModdel.toJson(),where: "id = ?",whereArgs: [event.id]);
      emit(OperasionalEditSucces());
    });
    on<DeleteData>((event, emit)async {
      var db = await database.getDatabase;
      db.delete('OPERASIONAL',where: "id = ?",whereArgs: [event.id]);
      emit(OperasionalDeleteSucces());
    });
  }
}
