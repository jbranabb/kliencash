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
    CREATE TABLE USERS(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    nama_perusahaan TEXT NOT NULL,
    alamat TETX NOT NULL,
    countryCode TEXT NOT NULL,
    handphone INTEGER NOT NULL,
    email TEXT NOT NULL,
    tagline TEXT
    )
    ''');

    await db.execute('''
   CREATE TABLE PAYMENT_METHOD(
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   type TEXT NOT NULL,
   name TEXT NOT NULL,
   number TEXT,
   account_name TEXT,
   isActive INTEGER NOT NULL
   ) 
    ''');

    await db.execute('''
      CREATE TABLE CLIENT(
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      handphone TEXT NOT NULL,
      country_code TEXT NOT NULL,
      alamat TEXT NOT NULL,
      createdAt TEXT 
      ) 
      ''');

    await db.execute('''
    CREATE TABLE PROJECTS(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,
    agenda TEXT NOT NULL,
    desc TEXT,
    status TEXT NOT NULL,
    startAt TEXT NOT NULL,
    endAt TEXT NOT NULL,
    estimatedValue INTEGER NOT NULL,
    createdAt TEXT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES CLIENT(Id) ON DELETE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE INVOICE(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    project_id INTEGER NOT NULL,
    payement_method_id INTEGER NOT NULL,
    status TEXT NOT NULL,
    title TEXT NOT NULL,
    subtotal INTEGER NOT NULL,
    pajak INTEGER,
    discount INTEGER,
    total_amount INTEGER NOT NULL,
    tanggal TEXT NOT NULL,
    jatuh_tempo TEXT NOT NULL,
    isRounded INTEGER NOT NULL,
    rounded_value INTEGER,     
    createdAt TEXT NOT NULL,
    invoice_number TEXT NOT NULL UNIQUE,
    notes TEXT,
    FOREIGN KEY (project_id) REFERENCES PROJECTS(Id) ON DELETE CASCADE
    FOREIGN KEY (payement_method_id) REFERENCES PAYMENT_METHOD(id) ON DELETE CASCADE
    )
      ''');
    await db.execute('''
    CREATE TABLE PAYMENT(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_id INTEGER NOT NULL,
    payment_method_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    tanggal_bayar TEXT NOT NULL,
    bukti_payment TEXT NOT NULL,
    notes TEXT,
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(Id) ON DELETE CASCADE
    FOREIGN KEY (payment_method_id) REFERENCES PAYMENT_METHOD(id) ON DELETE CASCADE
    )
    ''');
    await db.execute('''
    CREATE TABLE OPERASIONAL(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    project_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    amount INTEGER NOT NULL,
    date TEXT NOT NULL,
    FOREIGN KEY (project_id) REFERENCES PROJECTS(Id) ON DELETE CASCADE
    )    
    ''');
  }
}
