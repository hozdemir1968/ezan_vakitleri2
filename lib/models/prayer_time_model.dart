class PrayerTimeModel {
  int? id;
  String? fajr;
  String? sunrise;
  String? dhuhr;
  String? asr;
  String? maghrib;
  String? isha;
  String? shapeMoonUrl;
  String? astronomicalSunset;
  String? astronomicalSunrise;
  String? hijriDateShort;
  String? hijriDateShortIso8601;
  String? hijriDateLong;
  String? hijriDateLongIso8601;
  String? qiblaTime;
  String? gregorianDateShort;
  String? gregorianDateShortIso8601;
  String? gregorianDateLong;
  String? gregorianDateLongIso8601;
  int? greenwichMeanTimeZone;
  int? townId;
  String? townName;
  List<DateTime>? prayerTimes;
  String? savedDate;

  PrayerTimeModel({
    this.id,
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.isha,
    this.shapeMoonUrl,
    this.astronomicalSunset,
    this.astronomicalSunrise,
    this.hijriDateShort,
    this.hijriDateShortIso8601,
    this.hijriDateLong,
    this.hijriDateLongIso8601,
    this.qiblaTime,
    this.gregorianDateShort,
    this.gregorianDateShortIso8601,
    this.gregorianDateLong,
    this.gregorianDateLongIso8601,
    this.greenwichMeanTimeZone,
    this.townId,
    this.townName,
    this.prayerTimes,
    this.savedDate,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      fajr: json['fajr'],
      sunrise: json['sunrise'],
      dhuhr: json['dhuhr'],
      asr: json['asr'],
      maghrib: json['maghrib'],
      isha: json['isha'],
      shapeMoonUrl: json['shapeMoonUrl'],
      astronomicalSunset: json['astronomicalSunset'],
      astronomicalSunrise: json['astronomicalSunrise'],
      hijriDateShort: json['hijriDateShort'],
      hijriDateShortIso8601: json['hijriDateShortIso8601'],
      hijriDateLong: json['hijriDateLong'],
      hijriDateLongIso8601: json['hijriDateLongIso8601'],
      qiblaTime: json['qiblaTime'],
      gregorianDateShort: json['gregorianDateShort'],
      gregorianDateShortIso8601: json['gregorianDateShortIso8601'],
      gregorianDateLong: json['gregorianDateLong'],
      gregorianDateLongIso8601: json['gregorianDateLongIso8601'],
      greenwichMeanTimeZone: json['greenwichMeanTimeZone'],
      townId: json['townId'] ?? -1,
      townName: json['townName'] ?? "",
      prayerTimes: json['prayerTimes'] != null
          ? List<DateTime>.from(
              json['prayerTimes']?.map((x) => DateTime.fromMillisecondsSinceEpoch(x)),
            )
          : [],
      savedDate: json['savedDate'] ?? DateTime.now().toIso8601String(),
    );
  }

  factory PrayerTimeModel.fromMap(Map<String, dynamic> map) {
    return PrayerTimeModel(
      id: map['id'],
      fajr: map['fajr'],
      sunrise: map['sunrise'],
      dhuhr: map['dhuhr'],
      asr: map['asr'],
      maghrib: map['maghrib'],
      isha: map['isha'],
      shapeMoonUrl: map['shapeMoonUrl'],
      astronomicalSunset: map['astronomicalSunset'],
      astronomicalSunrise: map['astronomicalSunrise'],
      hijriDateShort: map['hijriDateShort'],
      hijriDateShortIso8601: map['hijriDateShortIso8601'],
      hijriDateLong: map['hijriDateLong'],
      hijriDateLongIso8601: map['hijriDateLongIso8601'],
      qiblaTime: map['qiblaTime'],
      gregorianDateShort: map['gregorianDateShort'],
      gregorianDateShortIso8601: map['gregorianDateShortIso8601'],
      gregorianDateLong: map['gregorianDateLong'],
      gregorianDateLongIso8601: map['gregorianDateLongIso8601'],
      greenwichMeanTimeZone: map['greenwichMeanTimeZone'],
      townId: map['townId'],
      townName: map['townName'],
      prayerTimes: map['prayerTimes'] != null
          ? List<DateTime>.from(
              map['prayerTimes']?.map((x) => DateTime.fromMillisecondsSinceEpoch(x)),
            )
          : null,
      savedDate: map['savedDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fajr': fajr,
      'sunrise': sunrise,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
      'shapeMoonUrl': shapeMoonUrl,
      'astronomicalSunset': astronomicalSunset,
      'astronomicalSunrise': astronomicalSunrise,
      'hijriDateShort': hijriDateShort,
      'hijriDateShortIso8601': hijriDateShortIso8601,
      'hijriDateLong': hijriDateLong,
      'hijriDateLongIso8601': hijriDateLongIso8601,
      'qiblaTime': qiblaTime,
      'gregorianDateShort': gregorianDateShort,
      'gregorianDateShortIso8601': gregorianDateShortIso8601,
      'gregorianDateLong': gregorianDateLong,
      'gregorianDateLongIso8601': gregorianDateLongIso8601,
      'greenwichMeanTimeZone': greenwichMeanTimeZone,
      'townId': townId,
      'townName': townName,
      'savedDate': savedDate,
    };
  }
}
