import 'package:bloc/bloc.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqlite_api.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc() : super(ClientInitial()) {
    final database = DatabaseHelper.instance.getDatabase;

    on<ReadDataClient>((event, emit) async {
      final db = await database;
      final client = await db.query("CLIENT");
      print(client);
    });

    Map<String, dynamic> clients = {
      "name":"Jibran",
      "handphone": 13242221,
      "alamat": "Jalan Jalan He"
    };
    on<PostDataClient>((event, emit) async {
      final db = await database;
      final results = await db.insert("CLIENT", clients);
      print(results);
    });
  }
}
