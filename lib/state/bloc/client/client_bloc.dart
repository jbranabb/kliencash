import 'package:bloc/bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:meta/meta.dart';
part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc() : super(ClientInitial()) {
    final database = DatabaseHelper.instance.getDatabase;

    on<ReadDataClient>((event, emit) async {
      emit(ClientLoading());
      final db = await database;
      final client = await db.query("CLIENT");
      List<ClientModel> dataClient = client
          .map((e) => ClientModel.fromJson(e))
          .toList();
      emit(ClientSucces(list: dataClient));
      print('fetching..');
    });

    on<PostDataClient>((event, emit) async {
      emit(ClientLoading());
      final db = await database;
      await db.insert("CLIENT", event.clientModel.toJson());
      emit(PostClientSucces());
    });
    on<EditDataClient>((event, emit) async {
      emit(ClientLoading());
      final db = await database;
      var data = event.clientModel.toJson();
      await db.update("CLIENT", data, where: "Id = ?", whereArgs: [event.id]);
      emit(EditClientSucces());
    });
    on<DeleteDataClient>((event, emit) async {
      emit(ClientLoading());
      final db = await database;
      await db.delete("CLIENT",where: "Id = ?",whereArgs: [event.id]);
      emit(DeleteClientSucces());
    });
  }
}
