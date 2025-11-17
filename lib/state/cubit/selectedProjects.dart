import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';

class SelectedProjects extends Cubit<Map<String,dynamic>> {
  SelectedProjects() : super({});
  var database = DatabaseHelper.instance;
  void selecProjects(int id)async{
      var db = await database.getDatabase;
      var results = await db.rawQuery('''
      SELECT PROJECTS.*,
      CLIENT.name as client_name,
      CLIENT.handphone as client_handphone,
      CLIENT.country_code as client_countryCode,
      CLIENT.alamat as client_alamat
      FROM PROJECTS INNER JOIN CLIENT ON PROJECTS.client_id = CLIENT.Id
      WHERE PROJECTS.id = ?
      ''', [id]);
      var state =  results[0];
      var data  =  {
        "Id": state['Id'], 
        "agenda": state['agenda'], 
        "desc": state['desc'], 
        "estimatedValue": state['estimatedValue'], 
        "startAt": state['startAt'], 
        "endAt": state['endAt'], 
        "status": state['status'], 
        "client_name": state['client_name'], 
      };
      emit(data);
  }
  void reset(){
    emit({});
  }
}