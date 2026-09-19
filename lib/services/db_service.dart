import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/plant_model.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agro_planner.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        area REAL NOT NULL,
        plantDate TEXT NOT NULL,
        harvestDate TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertPlant(Plant plant) async {
    final db = await database;
    return await db.insert(
      'plants',
      plant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Plant>> getPlants() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => Plant.fromMap(maps[i]));
  }

  Future<int> updatePlant(Plant plant) async {
    final db = await database;
    return await db.update(
      'plants',
      plant.toMap(),
      where: 'id = ?',
      whereArgs: [plant.id],
    );
  }

  Future<int> deletePlant(int id) async {
    final db = await database;
    return await db.delete(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
