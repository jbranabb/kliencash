import 'package:bloc/bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:meta/meta.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc() : super(ProjectsInitial()) {
    var database = DatabaseHelper.instance;
    on<ReadDataProjects>((event, emit) async {
      emit(ProjectsLoadingState());
      var db = await database.getDatabase;

      var results = await db.rawQuery('''
      SELECT PROJECTS.*,
      CLIENT.name as client_name,
      CLIENT.handphone as client_handphone,
      CLIENT.country_code as client_countryCode,
      CLIENT.alamat as client_alamat
      FROM PROJECTS INNER JOIN CLIENT ON PROJECTS.client_id = CLIENT.Id
      ''');

      List<ProjectsModel> data = results
          .map((e) => ProjectsModel.fromJson(e))
          .toList();
      emit(ProjectsSuccesState(list: data));
      print(data);
    });
    on<PostDataProjects>((event, emit) async {
      var db = await database.getDatabase;
      await db.insert("PROJECTS", event.projectsModel.toJson());
      emit(ProjectsPostSuccesState());
    });
    on<EditDataProjects>((event, emit) async {
     var db = await database.getDatabase;
     await db.update("PROJECTS", event.projectsModel.toJson(), where: "Id = ?", whereArgs: [event.id]); 
      emit(ProjectsEditSuccesState());
    });
    on<DeleteDataProjects>((event, emit) async{
      var db = await database.getDatabase;
      await db.delete("PROJECTS", where: 'Id = ?',whereArgs: [event.id]);
      emit(ProjectsDeleteSuccesState());
    });
  }
}
