import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';

class Selectedclient extends Cubit<Map<String, dynamic>>{
  Selectedclient(): super({});
  void selectedClient(int id)async{
    var db = await DatabaseHelper.instance.getDatabase;
    var results  = await db.query("CLIENT", where: "Id = ?", whereArgs: [id]);
    var data = results.map((e)=> ClientModel.fromJson(e)).toList();
    print(data[0].name);
    emit({
      "Id": data[0].id,
      "name": data[0].name,
      "handphone": data[0].handphone,
      "countryCode": data[0].countryCode,
      "almat": data[0].alamat,
      });
  }
  void reset(){
    emit({});
  }
}