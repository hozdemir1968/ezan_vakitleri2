import 'package:ezan_vakitleri/models/prayer_time_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemainingTime {
  List<RemainingTimeM> calcRemainingTimes(List<PrayerTimeModel> prayerTimeList) {
    List<RemainingTimeM> remainingTimeList = [];
    remainingTimeList = List.generate(
      7,
      (_) => RemainingTimeM(isVakit: false, isNext: false, diff: Duration.zero, remainingTime: "-"),
    );
    DateTime now = DateTime.now().toLocal();
    if (now.isBefore(prayerTimeList[0].prayerTimes![0])) {
      remainingTimeList[5].isVakit = true;
      remainingTimeList[0].isNext = true;
    } else if (now.isAfter(prayerTimeList[0].prayerTimes![0]) &&
        now.isBefore(prayerTimeList[0].prayerTimes![1])) {
      remainingTimeList[0].isVakit = true;
      remainingTimeList[1].isNext = true;
    } else if (now.isAfter(prayerTimeList[0].prayerTimes![1]) &&
        now.isBefore(prayerTimeList[0].prayerTimes![2])) {
      remainingTimeList[1].isVakit = true;
      remainingTimeList[2].isNext = true;
    } else if (now.isAfter(prayerTimeList[0].prayerTimes![2]) &&
        now.isBefore(prayerTimeList[0].prayerTimes![3])) {
      remainingTimeList[2].isVakit = true;
      remainingTimeList[3].isNext = true;
    } else if (now.isAfter(prayerTimeList[0].prayerTimes![3]) &&
        now.isBefore(prayerTimeList[0].prayerTimes![4])) {
      remainingTimeList[3].isVakit = true;
      remainingTimeList[4].isNext = true;
    } else if (now.isAfter(prayerTimeList[0].prayerTimes![4]) &&
        now.isBefore(prayerTimeList[0].prayerTimes![5])) {
      remainingTimeList[4].isVakit = true;
      remainingTimeList[5].isNext = true;
    } else if (now.isAfter(prayerTimeList[0].prayerTimes![5]) &&
        now.isBefore(prayerTimeList[1].prayerTimes![0])) {
      remainingTimeList[5].isVakit = true;
      remainingTimeList[6].isNext = true;
    } else {
      remainingTimeList[5].isVakit = true;
      remainingTimeList[6].isNext = true;
    }
    for (int i = 0; i < 7; i++) {
      if (i == 6) {
        remainingTimeList[i].diff = (prayerTimeList[1].prayerTimes![0]).difference(
            now.subtract(Duration(seconds: 59)));
      } else {
        remainingTimeList[i].diff = (prayerTimeList[0].prayerTimes![i].difference(
          now.subtract(Duration(seconds: 59)),
        ));
      }
      remainingTimeList[i].remainingTime = remainingTimeStr(remainingTimeList[i]);
    }
    return remainingTimeList;
  }

  String remainingTimeStr(RemainingTimeM remainingTimeM) {
    if (remainingTimeM.remainingTime!.isEmpty || remainingTimeM.diff!.isNegative) {
      return '-';
    } else if (remainingTimeM.diff!.inHours == 0) {
      if (remainingTimeM.diff!.inMinutes == 0) {
        return 'Ezan Vakti !';
      } else {
        return '${remainingTimeM.diff!.inMinutes % 60} ${'dakika'}';
      }
    } else if (remainingTimeM.diff!.inMinutes % 60 == 0) {
      return '${remainingTimeM.diff!.inHours} ${'saat'}';
    } else {
      return '${remainingTimeM.diff!.inHours} ${'saat'} ${remainingTimeM.diff!.inMinutes % 60} ${'dakika'}';
    }
  }
}

class RemainingTimeM {
  bool? isVakit;
  bool? isNext;
  Duration? diff;
  String? remainingTime;

  RemainingTimeM({this.isVakit, this.isNext, this.diff, this.remainingTime});
}

//
final remainingTimesProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 10), (_) => DateTime.now());
});
