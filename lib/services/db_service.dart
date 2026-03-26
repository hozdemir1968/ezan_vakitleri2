import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/daily_model.dart';
import '../models/prayer_time_model.dart';
import '../models/saved_town_model.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_cache.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS prayertimetable (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        fajr TEXT,
        sunrise TEXT,
        dhuhr TEXT,
        asr TEXT,
        maghrib TEXT,
        isha TEXT,
        shapeMoonUrl TEXT,
        astronomicalSunset TEXT,
        astronomicalSunrise TEXT,
        hijriDateShort TEXT,
        hijriDateShortIso8601 TEXT,
        hijriDateLong TEXT,
        hijriDateLongIso8601 TEXT,
        qiblaTime TEXT,
        gregorianDateShort TEXT,
        gregorianDateShortIso8601 TEXT,
        gregorianDateLong TEXT,
        gregorianDateLongIso8601 TEXT,
        greenwichMeanTimeZone INTEGER,
        townId INTEGER,
        townName TEXT,
        prayerTimes TEXT,
        savedDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS dailytable (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        dayOfYear INTEGER,
        verse TEXT,
        verseSource TEXT,
        hadith TEXT,
        hadithSource TEXT,
        pray TEXT,
        praySource TEXT,
        savedDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS savedtowntable (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        townId INTEGER,
        townName TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    //
  }

  // PRAYERTIMES
  Future<void> savePrayerTimes(List<PrayerTimeModel> model) async {
    final db = await database;
    final batch = db.batch();
    for (final data in model) {
      batch.insert('prayertimetable', data.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<PrayerTimeModel>> getPrayerTimes(int id) async {
    final db = await database;
    final datas = await db.query('prayertimetable', where: 'townId = ?', whereArgs: [id]);
    return datas.map((m) => PrayerTimeModel.fromMap(m)).toList();
  }

  Future<void> deletePrayerTimes() async {
    final db = await database;
    db.delete('prayertimetable');
  }

  Future<void> deletePrayerTimesBy(int id) async {
    final db = await database;
    db.delete('prayertimetable', where: 'townId = ?', whereArgs: [id]);
  }

  // DAILY
  Future<void> saveDaily(DailyModel model) async {
    final db = await database;
    db.insert('dailytable', model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<DailyModel?> getDaily() async {
    final db = await database;
    final data = await db.query('dailytable');
    return DailyModel.fromMap(data.first);
  }

  Future<void> deleteDailies() async {
    final db = await database;
    db.delete('dailytable');
  }

  // SAVED TOWNS
  Future<void> saveTown(SavedTownModel model) async {
    final db = await database;
    db.insert('savedtowntable', model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SavedTownModel>> getTowns() async {
    final db = await database;
    final datas = await db.query('savedtowntable');
    return datas.map((m) => SavedTownModel.fromMap(m)).toList();
  }

  Future<void> deleteTownBy(int id) async {
    final db = await database;
    db.delete('savedtowntable', where: 'townId = ?', whereArgs: [id]);
  }

  // CACHE KONTROL
  Future<CacheStatus> checkCacheStatus(String tableName) async {
    final db = await database;
    // Kayıt sayısını kontrol et
    final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableName');
    final count = Sqflite.firstIntValue(countResult) ?? 0;
    if (count == 0) {
      return CacheStatus.empty;
    }
    // En son çekilme zamanına bak
    final result = await db.rawQuery(
      'SELECT savedDate FROM $tableName ORDER BY savedDate DESC LIMIT 1',
    );
    if (result.isEmpty || result.first['savedDate'] == null) {
      return CacheStatus.outdated;
    }
    final fetchedAt = DateTime.parse(result.first['savedDate'] as String);
    final now = DateTime.now();
    // Aynı gün mü?
    final sameDay =
        fetchedAt.year == now.year && fetchedAt.month == now.month && fetchedAt.day == now.day;

    return sameDay ? CacheStatus.fresh : CacheStatus.outdated;
  }

  /// Cache'i temizle
  Future<void> clearCache(String tableName) async {
    final db = await database;
    await db.delete(tableName);
  }
}

enum CacheStatus {
  fresh, // Veri var ve bugün çekilmiş
  outdated, // Veri var ama bugün değil
  empty, // Hiç veri yok
}
