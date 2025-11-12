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
      country_code TEXT NOT NULL,
      alamat TEXT NOT NULL) 
      ''');

    await db.execute('''
    CREATE TABLE PROJECTS(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,
    agenda TEXT NOT NULL,
    status TEXT NOT NULL,
    createdAt TEXT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES CLIENT(Id) ON DELETE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE INVOICE(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    project_id INTEGER NOT NULL,
    status TEXT NOT NULL,
    subtotal REAL NOT NULL,
    pajak REAL NOT NULL,
    discount REAL NOT NULL,
    total_amount REAL NOT NULL,
    tanggal TEXT NOT NULL,    
    jatuh_tempo TEXT NOT NULL,    
    createdAt TEXT NOT NULL,
    invoice_number TEXT NOT NULL UNIQUE,
    notes TEXT,
    FOREIGN KEY (project_id) REFERENCES PROJECTS(Id) ON DELETE CASCADE
    )
      ''');

    await db.execute('''
    CREATE TABLE PAYMENT(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    tanggal_bayar TEXT NOT NULL,
    payment_method TEXT NOT NULL,
    bukti_payment TEXT NOT NULL,
    notes TEXT,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(Id) ON DELETE CASCADE
    )
    ''');
  }
}
