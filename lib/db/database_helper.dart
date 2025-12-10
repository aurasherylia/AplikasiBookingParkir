import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/booking.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _db;

  // ===============================
  // INIT DATABASE
  // ===============================
  Future<void> init() async {
    _db ??= await _initDb();
  }

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'parking_app.db');

    return openDatabase(
      path,
      version: 20, // UPGRADE VERSION IF NEEDED
      onCreate: (db, version) async => await _createTables(db),
      onUpgrade: (db, oldVersion, newVersion) async => await _createTables(db),
    );
  }

  // ===============================
  // CREATE ALL TABLES
  // ===============================
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uniqueId TEXT,
        areaName TEXT,
        slot TEXT,
        startTime TEXT,
        endTime TEXT,
        createdAt TEXT,
        isActive INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS slots(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        areaName TEXT,
        slotName TEXT,
        isBooked INTEGER
      )
    ''');
  }

  // ===============================
  // GENERATE UNIQUE CODE "CPA-XXXX"
  // ===============================
  String generateUniqueId(int id) {
    return "CPA-${id.toString().padLeft(4, '0')}";
  }

  // ===============================
  // INSERT BOOKING
  // ===============================
  Future<int> insertBooking(Booking booking) async {
    final db = await database;

    // Insert awal → dapatkan ID
    int newId = await db.insert(
      'bookings',
      {
        'uniqueId': 'TEMP',
        'areaName': booking.areaName,
        'slot': booking.slot,
        'startTime': booking.startTime,
        'endTime': booking.endTime,
        'createdAt': booking.createdAt,
        'isActive': 1,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Generate Unique ID
    String realId = generateUniqueId(newId);

    // Update dengan uniqueId final
    await db.update(
      'bookings',
      {'uniqueId': realId},
      where: 'id = ?',
      whereArgs: [newId],
    );

    // Tandai slot sebagai booked
    await bookSlot(booking.areaName, booking.slot);

    return newId;
  }

  // ===============================
  // GET ALL BOOKINGS
  // ===============================
  Future<List<Booking>> getAllBookings() async {
    final db = await database;
    final res = await db.query('bookings', orderBy: 'id DESC');
    return res.map((e) => Booking.fromMap(e)).toList();
  }

  // ===============================
  // GET ACTIVE BOOKINGS (SECURITY)
  // ===============================
  Future<List<Booking>> getActiveBookings() async {
    final db = await database;
    final res = await db.query('bookings', where: 'isActive = 1');
    return res.map((e) => Booking.fromMap(e)).toList();
  }

  // ===============================
  // SECURITY – FIND BY UNIQUE ID
  // ===============================
  Future<Booking?> getBookingByUniqueId(String uniqueId) async {
    final db = await database;
    final res = await db.query(
      'bookings',
      where: 'uniqueId = ?',
      whereArgs: [uniqueId],
    );
    if (res.isEmpty) return null;
    return Booking.fromMap(res.first);
  }

  // ===============================
  // SECURITY – FINISH BOOKING
  // ===============================
  Future<void> finishBooking(int id) async {
    final db = await database;
    await db.update(
      'bookings',
      {'isActive': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ===============================
  // BOOK SLOT
  // ===============================
  Future<void> bookSlot(String areaName, String slotName) async {
    final db = await database;

    final existed = await db.query(
      'slots',
      where: 'areaName = ? AND slotName = ?',
      whereArgs: [areaName, slotName],
    );

    if (existed.isEmpty) {
      await db.insert('slots', {
        'areaName': areaName,
        'slotName': slotName,
        'isBooked': 1,
      });
    } else {
      await db.update(
        'slots',
        {'isBooked': 1},
        where: 'areaName = ? AND slotName = ?',
        whereArgs: [areaName, slotName],
      );
    }
  }

  // ===============================
  // CHECK SLOT STATUS
  // ===============================
  Future<bool> isSlotBooked(String areaName, String slotName) async {
    final db = await database;

    final res = await db.query(
      'slots',
      where: 'areaName = ? AND slotName = ?',
      whereArgs: [areaName, slotName],
    );

    if (res.isEmpty) return false;
    return res.first['isBooked'] == 1;
  }
}
