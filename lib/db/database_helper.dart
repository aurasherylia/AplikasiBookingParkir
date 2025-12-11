import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/booking.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _db;

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
      version: 26,
      onCreate: (db, version) => _createTables(db),
      onUpgrade: (db, oldVersion, newVersion) => _createTables(db),
    );
  }

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
        isActive INTEGER,
        plateNumber TEXT
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

  String _genUniqueId(int id) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    final random = List.generate(5, (_) => chars[rand.nextInt(chars.length)]).join();
    return "CPA-${id.toString().padLeft(4, '0')}-$random";
  }

  Future<Booking> insertBooking(Booking b) async {
    final db = await database;

    int newId = await db.insert("bookings", {
      'uniqueId': 'TEMP',
      'areaName': b.areaName,
      'slot': b.slot,
      'startTime': b.startTime,
      'endTime': b.endTime,
      'createdAt': b.createdAt,
      'isActive': b.isActive,
      'plateNumber': b.plateNumber,
    });

    final uid = _genUniqueId(newId);

    await db.update(
      'bookings',
      {'uniqueId': uid},
      where: 'id = ?',
      whereArgs: [newId],
    );

    await bookSlot(b.areaName, b.slot);

    return Booking(
      id: newId,
      uniqueId: uid,
      areaName: b.areaName,
      slot: b.slot,
      startTime: b.startTime,
      endTime: b.endTime,
      createdAt: b.createdAt,
      isActive: 1,
      plateNumber: b.plateNumber,
    );
  }

  Future<List<Booking>> getActiveBookings() async {
    final db = await database;
    final res = await db.query("bookings", where: "isActive = 1");
    return res.map((e) => Booking.fromMap(e)).toList();
  }

  Future<List<Booking>> getAllBookings() async {
    final db = await database;
    final res = await db.query("bookings", orderBy: "id DESC");
    return res.map((e) => Booking.fromMap(e)).toList();
  }

  Future<Booking?> getBookingByUniqueId(String code) async {
    final db = await database;
    final res = await db.query(
      'bookings',
      where: 'uniqueId = ?',
      whereArgs: [code],
    );
    if (res.isEmpty) return null;
    return Booking.fromMap(res.first);
  }

  Future<void> finishBooking(int id) async {
    final db = await database;
    await db.update(
      'bookings',
      {'isActive': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> bookSlot(String area, String slot) async {
    final db = await database;

    final exist = await db.query(
      'slots',
      where: 'areaName = ? AND slotName = ?',
      whereArgs: [area, slot],
    );

    if (exist.isEmpty) {
      await db.insert('slots', {
        'areaName': area,
        'slotName': slot,
        'isBooked': 1,
      });
    } else {
      await db.update(
        'slots',
        {'isBooked': 1},
        where: 'areaName = ? AND slotName = ?',
        whereArgs: [area, slot],
      );
    }
  }

  Future<bool> isSlotBooked(String a, String s) async {
    final db = await database;
    final res = await db.query(
      'slots',
      where: 'areaName = ? AND slotName = ?',
      whereArgs: [a, s],
    );

    if (res.isEmpty) return false;
    return res.first['isBooked'] == 1;
  }
}
