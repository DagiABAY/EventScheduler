import 'package:sample_test_app_for_job/models/event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "events.db";
  static final _databaseVersion = 1;

  static final table = 'events';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnDescription = 'description';
  static final columnStartTime = 'startTime';
  static final columnEndTime = 'endTime';
  static final columnType = 'type';
  static final columnDate = 'date';
  static final columnImagePaths = 'imagePaths';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT,
        $columnDescription TEXT,
        $columnStartTime TEXT,
        $columnEndTime TEXT,
        $columnType TEXT,
        $columnDate TEXT,
                $columnImagePaths TEXT

      )
    ''');
  }

  Future<int> insert(Events event) async {
    Database db = await instance.database;
    return await db.insert(table, event.toMap());
  }

  Future<List<Events>> getEventsForDate(String date) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnDate = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) {
      return Events.fromMap(maps[i]);
    });
  }

  Future<List<Events>> getAllEvents() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Events.fromMap(maps[i]);
    });
  }

  Future<int> update(Events event) async {
    Database db = await instance.database;
    return await db.update(
      table,
      event.toMap(),
      where: '$columnId = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
