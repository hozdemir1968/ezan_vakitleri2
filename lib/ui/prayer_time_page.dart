import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../components/drawer_menu.dart';
import '../components/statics.dart';
import '../components/styles.dart';
import '../controllers/providers.dart';
import '../controllers/remaining_time.dart';
import '../controllers/selected_town_notifier.dart';
import '../models/daily_model.dart';
import '../models/prayer_time_model.dart';

class PrayerTimePage extends ConsumerWidget {
  const PrayerTimePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final townId = ref.watch(selectedTownIdProvider);
    final prayerData = ref.watch(prayerTimeProvider(townId));

    return Scaffold(
      appBar: AppBar(
        title: prayerData.when(
          loading: () => const Text("Ezan Vakitleri"),
          error: (err, stack) => const Text("Ezan Vakitleri"),
          data: (data) => Text(data.prayerTimes?.first.townName ?? "Ezan Vakitleri"),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      drawer: DrawerMenu(townId: townId),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(prayerTimeProvider(townId));
          await ref.read(prayerTimeProvider(townId).future);
        },
        child: prayerData.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Hata oluştu: $err')),
          data: (data) {
            final prayerTimes = data.prayerTimes!;
            return _content(context, ref, prayerTimes, data.daily!);
          },
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    WidgetRef ref,
    List<PrayerTimeModel> prayerTimes,
    DailyModel daily,
  ) {
    // ignore: unused_local_variable
    final remainingTimeAsync = ref.watch(remainingTimesProvider);

    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        _dateCard(prayerTimes),
        const SizedBox(height: 10),
        _prayerTimeTable(prayerTimes),
        const SizedBox(height: 10),
        _verseCard(daily),
        const SizedBox(height: 10),
        _hadithCard(daily),
      ],
    );
  }

  Widget _dateCard(List<PrayerTimeModel> prayerTimes) {
    final model = prayerTimes.first;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                DateFormat.yMMMMEEEEd(
                  trTR.countryCode,
                ).format(DateTime.parse(model.gregorianDateLongIso8601 ?? "").toLocal()),
                style: textStyle20B(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text(model.hijriDateLong.toString(), style: textStyle18()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prayerTimeTable(List<PrayerTimeModel> prayerTimes) {
    final model = prayerTimes.first;
    final remainingTimes = RemainingTime().calcRemainingTimes(prayerTimes);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    Text(' Vakit', style: textStyle18B()),
                    Text('Vakti', style: textStyle18B()),
                    Text('Kalan Süre', style: textStyle18B()),
                  ],
                ),
                ...List.generate(6, (index) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(' ${vakits[index]}', style: textStyle18B()),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          DateFormat('Hm').format(model.prayerTimes![index]),
                          style: remainingTimes[index].isVakit!
                              ? textStyle18BT()
                              : remainingTimes[index].isNext!
                              ? textStyle18BO()
                              : textStyle18B(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 6),
                        child: Text(
                          remainingTimes[index].remainingTime.toString(),
                          style: textStyle18(),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            remainingTimes[6].isNext!
                ? Text("İmsağa ${remainingTimes[6].remainingTime!} kaldı", style: textStyle18B())
                : Text(""),
          ],
        ),
      ),
    );
  }

  Widget _verseCard(DailyModel daily) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bir Ayet", style: textStyle18B()),
            SizedBox(
              width: double.infinity,
              child: Text(
                'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ',
                style: textStyle24B(),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            Text(daily.verse ?? "", style: textStyle16()),
            SizedBox(
              width: double.infinity,
              child: Text(
                daily.verseSource.toString(),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hadithCard(DailyModel daily) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bir Hadis", style: textStyle18B()),
            SizedBox(height: 8),
            Text(daily.hadith ?? "", style: textStyle16()),
            SizedBox(
              width: double.infinity,
              child: Text(
                daily.hadithSource.toString(),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
