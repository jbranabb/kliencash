import 'package:bloc/bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:meta/meta.dart';
import 'package:kliencash/data/model/model.dart';
part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    var database = DatabaseHelper.instance;
    on<ReadDataUsers>((event, emit) async {
      var db = await database.getDatabase;
      var data =  await db.query('''USERS''');
      var results =  data.map((e)=> User.fromJson(e)).toList();
      emit(UsersSucces(list: results));
    });
    on<PostDataUsers>((event, emit) async {
      var db = await database.getDatabase;
      await db.insert("USERS", event.user.toJson());
      emit(UsersPostSucces());
    });
  }
}
