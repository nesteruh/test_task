import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_task/data/models/task.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();

  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTasks ( 
      ${TaskFields.id} $idType, 
      ${TaskFields.name} $textType,
      ${TaskFields.status} $textType,
      ${TaskFields.period} $textType,
      ${TaskFields.progress} $doubleType,
      ${TaskFields.fieldName} $textType,
      ${TaskFields.area} $textType,
      ${TaskFields.brandMachine} $textType,
      ${TaskFields.modelMachine} $textType,
      ${TaskFields.typeMachine} $textType,
      ${TaskFields.nameStaffMachine} $textType,
      ${TaskFields.positionStaffMachine} $textType,
      ${TaskFields.nameStaff} $textType,
      ${TaskFields.positionStaff} $textType
    )
    ''');
  }

  Future<void> insertTask(Task task) async {
    final db = await instance.database;
    await db.insert(tableTasks, task.toJson());
  }

  Future<void> insertTasks(List<Task> tasks) async {
    final db = await instance.database;
    for (var task in tasks) {
      await db.insert(tableTasks, task.toJson());
    }
  }

  Future<List<Task>> fetchTasks() async {
    final db = await instance.database;
    final result = await db.query(tableTasks);

    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
