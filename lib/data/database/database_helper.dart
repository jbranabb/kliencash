import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get getDatabase async {
    if (_database != null) return _database!;
    _database = await _initDB('clientcash.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE CLIENT(
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      handphone TEXT NOT NULL,
      alamat TEXT NOT NULL)
      ''');
    print('database dan table berhasil di buat !!!');
  }
}
