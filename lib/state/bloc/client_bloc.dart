import 'package:bloc/bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/client_model.dart';
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
     List<ClientModel> dataClient =  client.map((e) => ClientModel.fromJson(e)).toList();
     emit(ClientSucces(list: dataClient));
     print('fetching..');
    });

    on<PostDataClient>((event, emit) async {
      final db = await database;
      final results = await db.insert("CLIENT", event.clientModel.toJson());
      print(results);
    });
  }
}
