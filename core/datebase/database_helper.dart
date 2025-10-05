import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;

  DatabaseHelper._init();
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('car_maintenance.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
    CREATE TABLE vehicles (
      id $idType,
      make $textType,
      model $textType,
      year $intType,
      licensePlate TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE maintenance_records (
      id $idType,
      vehicleId $intType,
      date $textType,
      mileage $intType,
      servicePlace $textType,
      description $textType,
      laborCost $realType,
      partsCost $realType,
      totalCost $realType,
      notes TEXT,
      FOREIGN KEY (vehicleId) REFERENCES vehicles (id)
    )
    ''');
  }

  Future<int> createVehicle(Map<String, dynamic> v) async {
    final db = await database;
    return await db.insert('vehicles', v);
  }

  Future<List<Map<String, dynamic>>> getVehicles() async {
    final db = await database;
    return await db.query('vehicles');
  }

  Future<int> createMaintenance(Map<String, dynamic> m) async {
    final db = await database;
    return await db.insert('maintenance_records', m);
  }

  Future<List<Map<String, dynamic>>> getMaintenanceForVehicle(int vid) async {
    final db = await database;
    return await db.query(
      'maintenance_records',
      where: 'vehicleId = ?',
      whereArgs: [vid],
      orderBy: 'date DESC',
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
