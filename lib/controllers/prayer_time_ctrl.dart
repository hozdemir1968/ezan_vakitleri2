import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import '../models/daily_model.dart';
import '../models/prayer_time_model.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

class PrayerTimeCtrl {
  final ApiService _apiService;
  final DBService _dbService;

  PrayerTimeCtrl({ApiService? apiService, DBService? dbService})
    : _apiService = apiService ?? ApiService(),
      _dbService = dbService ?? DBService();

  Future<DataResult> getDatas(int townId) async {
    List<PrayerTimeModel>? prayerTimes = [];
    DailyModel? daily = DailyModel();
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    try {
      final cacheStatus = await _dbService.checkCacheStatus('prayertimetable');
      if (cacheStatus == CacheStatus.fresh) {
        // DB
        debugPrint("DB");
        prayerTimes = await _dbService.getPrayerTimes(townId);
        prayerTimes = addPrayerTimesToList(prayerTimes);
        daily = await _dbService.getDaily();
      } else {
        // API
        debugPrint("API");
        prayerTimes = await _apiService.getPrayerTimes(townId);
        prayerTimes.removeWhere(
          (item) => DateTime.parse(item.gregorianDateLongIso8601!).isBefore(today),
        );
        prayerTimes = addPrayerTimesToList(prayerTimes);
        prayerTimes = addTownToList(prayerTimes);
        await _dbService.deletePrayerTimesBy(townId);
        await _dbService.savePrayerTimes(prayerTimes);
        daily = await _apiService.getDaily();
        await _dbService.saveDaily(daily);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return DataResult(prayerTimes: prayerTimes, daily: daily);
  }

  List<PrayerTimeModel> addPrayerTimesToList(List<PrayerTimeModel> prayerTimeList) {
    if (prayerTimeList.isNotEmpty) {
      for (int i = 0; i < prayerTimeList.length - 1; i++) {
        DateTime date = DateTime.parse(prayerTimeList[i].gregorianDateLongIso8601!).toLocal();
        prayerTimeList[i].prayerTimes = [
          mergeDateTimeD(date.year, date.month, date.day, prayerTimeList[i].fajr!),
          mergeDateTimeD(date.year, date.month, date.day, prayerTimeList[i].sunrise!),
          mergeDateTimeD(date.year, date.month, date.day, prayerTimeList[i].dhuhr!),
          mergeDateTimeD(date.year, date.month, date.day, prayerTimeList[i].asr!),
          mergeDateTimeD(date.year, date.month, date.day, prayerTimeList[i].maghrib!),
          mergeDateTimeD(date.year, date.month, date.day, prayerTimeList[i].isha!),
        ];
      }
    }
    return prayerTimeList;
  }

  List<PrayerTimeModel> addTownToList(List<PrayerTimeModel> prayerTimeList) {
    final box = GetStorage();
    if (prayerTimeList.isNotEmpty) {
      for (int i = 0; i < prayerTimeList.length; i++) {
        prayerTimeList[i].townId = box.read('townId');
        prayerTimeList[i].townName = box.read('townName');
      }
    }
    return prayerTimeList;
  }

  DateTime mergeDateTimeD(int year, int month, int day, String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(year, month, day, hour, minute);
  }
}

class DataResult {
  final List<PrayerTimeModel>? prayerTimes;
  final DailyModel? daily;
  const DataResult({required this.prayerTimes, required this.daily});
}
