import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../components/custom_theme.dart';
import '../components/drawer_menu.dart';
import '../components/statics.dart';
import '../controllers/prayer_time_ctrl.dart';
import '../controllers/remaining_time.dart';
import '../controllers/selected_town_notifier.dart';

import '../models/prayer_time_model.dart';

class PrayerTimesPage extends ConsumerWidget {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final townId = ref.watch(selectedTownIdProvider);
    final prayerData = ref.watch(prayerTimesProvider(townId));

    return Scaffold(
      appBar: AppBar(
        title: prayerData.when(
          data: (data) => Text(data.prayerTimes?.first.townName ?? "Ezan Vakitleri"),
          error: (err, stack) => const Text("Ezan Vakitleri"),
          loading: () => const Text("Ezan Vakitleri"),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      drawer: DrawerMenu(townId: townId),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(prayerTimesProvider(townId));
          await ref.read(prayerTimesProvider(townId).future);
        },
        child: prayerData.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Hata: $err")),
          data: (data) {
            final list = data.prayerTimes ?? [];
            return ListView.builder(
              itemCount: list.length - 1,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) => PrayerCard(prayerTimes: list, index: index),
            );
          },
        ),
      ),
    );
  }
}

class PrayerCard extends ConsumerWidget {
  final List<PrayerTimeModel> prayerTimes;
  final int index;

  const PrayerCard({super.key, required this.prayerTimes, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final remainingTimeAsync = ref.watch(remainingTimesProvider);
    final remainingTimes = RemainingTime().calcRemainingTimes(prayerTimes);
    bool isToday = index == 0 ? true : false;
    int nextIndex = remainingTimes.indexWhere((e) => e.isNext == true);
    if (nextIndex == -1) nextIndex = 0;
    final PrayerTimeModel model = prayerTimes[index];

    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                DateFormat.yMMMMEEEEd(
                  'tr',
                ).format(DateTime.parse(model.gregorianDateLongIso8601.toString()).toLocal()),
                style: textStyle20B(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text(model.hijriDateLong.toString(), style: textStyle18()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: vakits.map((vakit) => Text(vakit, style: textStyle18())).toList(),
            ),
            isToday
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (i) {
                          final rt = remainingTimes[i];
                          return Text(
                            DateFormat('Hm').format(model.prayerTimes![i]),
                            style: rt.isVakit!
                                ? textStyle18BT()
                                : (rt.isNext! ? textStyle18BO() : textStyle18B()),
                          );
                        }),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${vakite[nextIndex]} ${remainingTimes[nextIndex].remainingTime} kaldı',
                        style: textStyle19(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (i) {
                          return Text(
                            DateFormat('Hm').format(model.prayerTimes![i]),
                            style: textStyle18B(),
                          );
                        }),
                      ),
                    ],
                  ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
