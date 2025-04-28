import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'carpool.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // Create the users table for login, registration, and password retrieval
    await db.execute('''
      CREATE TABLE users (
        userID INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        security_question TEXT NOT NULL,
        security_answer TEXT NOT NULL
      )
    ''');

    // Create the carpools table
    await db.execute('''
      CREATE TABLE carpools (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userID INTEGER NOT NULL,
        pickUpPoint TEXT NOT NULL,
        dropOffPoint TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        availableSeats INTEGER NOT NULL,
        ridePreference TEXT,
        status TEXT DEFAULT 'active',
        earnings REAL DEFAULT 0.0,
        FOREIGN KEY(userID) REFERENCES users(userID)
      )
    ''');

    // Create the carpool history table
    await db.execute('''
      CREATE TABLE carpool_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        carpoolID INTEGER NOT NULL,
        userID INTEGER NOT NULL,
        status TEXT,
        earnings REAL DEFAULT 0.0,
        FOREIGN KEY(carpoolID) REFERENCES carpools(id),
        FOREIGN KEY(userID) REFERENCES users(userID)
      )
    ''');
  }

  // Insert a new user
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(
      'users',  // Table name
      user,     // User data to insert
      conflictAlgorithm: ConflictAlgorithm.replace, // In case of conflict, replace
    );
  }
  // Update the carpool status (completed or canceled)
  Future<void> updateCarpoolStatus(int carpoolID, String status) async {
    final db = await database;
    await db.update(
      'carpools',
      {'status': status},
      where: 'id = ?',
      whereArgs: [carpoolID],
    );
  }
// Insert a new carpool into the database
  Future<int> insertCarpool(Map<String, dynamic> carpool) async {
    final db = await database;
    return await db.insert(
      'carpools',  // Table name
      carpool,     // Carpool data to insert
      conflictAlgorithm: ConflictAlgorithm.replace, // In case of conflict, replace
    );
  }


  // Get user by email (used for login and password retrieval)
  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Update user password
  Future<void> updateUserPassword(String email, String newPassword) async {
    final db = await database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Fetch all completed or canceled carpools for the user in carpool history
  Future<List<Map<String, dynamic>>> getCarpoolHistory(int userID) async {
    final db = await database;
    return await db.query(
      'carpool_history',
      where: 'userID = ? AND (status = ? OR status = ?)',  // Completed or Canceled
      whereArgs: [userID, 'completed', 'canceled'],
      orderBy: 'status DESC',  // Order by status (completed first, then canceled)
    );
  }

  // Fetch active carpools for the Registered Carpool page
  Future<List<Map<String, dynamic>>> getCarpools(int userID) async {
    final db = await database;
    return await db.query(
      'carpools',
      where: 'userID = ? AND status = ?',
      whereArgs: [userID, 'active'],
      orderBy: 'date DESC',
    );
  }

  // Insert carpool history (either completed or canceled)
  Future<void> addCarpoolHistory(int carpoolID, int userID, String status, double earnings) async {
    final db = await database;
    await db.insert(
      'carpool_history',
      {
        'carpoolID': carpoolID,
        'userID': userID,
        'status': status,
        'earnings': earnings,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
