import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _db;
  static const int _dbVersion = 1;

  static Future<Database> instance() async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'arabist.db');

    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return _db!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        arabic TEXT,
        kazakh TEXT,
        russian TEXT,
        description TEXT
      );
    ''');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await _refresh(db);
  }

  static Future<void> refreshDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'arabist.db');
    if (File(path).existsSync()) {
      await deleteDatabase(path);
      print('🧹 Database refreshed');
    }
    _db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  static Future<void> _refresh(Database db) async {
    await db.execute('DROP TABLE IF EXISTS words;');
    await _onCreate(db, _dbVersion);
  }
}
