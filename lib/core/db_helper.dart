import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;
  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mentu.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL UNIQUE,
      name TEXT,
      password_hash TEXT NOT NULL,
      role TEXT NOT NULL
    );
    ''');

    await db.execute('''
    CREATE TABLE tasks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT,
      subject TEXT,
      due_date TEXT,
      priority TEXT,
      completed INTEGER DEFAULT 0,
      FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE availabilities(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tutor_id INTEGER NOT NULL,
      date TEXT NOT NULL,
      start_time TEXT,
      end_time TEXT,
      FOREIGN KEY(tutor_id) REFERENCES users(id) ON DELETE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE bookings(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      student_id INTEGER NOT NULL,
      tutor_id INTEGER NOT NULL,
      availability_id INTEGER NOT NULL,
      date TEXT NOT NULL,
      start_time TEXT,
      end_time TEXT,
      status TEXT DEFAULT 'booked',
      FOREIGN KEY(student_id) REFERENCES users(id),
      FOREIGN KEY(tutor_id) REFERENCES users(id),
      FOREIGN KEY(availability_id) REFERENCES availabilities(id)
    );
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
