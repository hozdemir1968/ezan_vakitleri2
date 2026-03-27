import 'daily_model.dart';
import 'prayer_time_model.dart';

class DataResult {
  final List<PrayerTimeModel>? prayerTimes;
  final DailyModel? daily;
  const DataResult({required this.prayerTimes, required this.daily});
}
