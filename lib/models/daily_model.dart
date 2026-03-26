class DailyModel {
  int? id;
  int? dayOfYear;
  String? verse;
  String? verseSource;
  String? hadith;
  String? hadithSource;
  String? pray;
  String? praySource;
  String? savedDate;

  DailyModel({
    this.id,
    this.dayOfYear,
    this.verse,
    this.verseSource,
    this.hadith,
    this.hadithSource,
    this.pray,
    this.praySource,
    this.savedDate,
  });

  factory DailyModel.fromJson(Map<String, dynamic> json) {
    return DailyModel(
      id: json['id'],
      dayOfYear: json['dayOfYear'],
      verse: json['verse'],
      verseSource: json['verseSource'],
      hadith: json['hadith'],
      hadithSource: json['hadithSource'],
      pray: json['pray'],
      praySource: json['praySource'],
      savedDate: json['savedDate'],
    );
  }

  factory DailyModel.fromMap(Map<String, dynamic> map) {
    return DailyModel(
      id: map['id'],
      dayOfYear: map['dayOfYear'],
      verse: map['verse'],
      verseSource: map['verseSource'],
      hadith: map['hadith'],
      hadithSource: map['hadithSource'],
      pray: map['pray'],
      praySource: map['praySource'],
      savedDate: map['savedDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayOfYear': dayOfYear,
      'verse': verse,
      'verseSource': verseSource,
      'hadith': hadith,
      'hadithSource': hadithSource,
      'pray': pray,
      'praySource': praySource,
      'savedDate': savedDate,
    };
  }
}
