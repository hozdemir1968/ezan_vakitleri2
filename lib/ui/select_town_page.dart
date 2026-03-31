import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/selection_ctrl.dart';
import '../controllers/selected_town_notifier.dart';
import '../models/saved_town_model.dart';
import '../services/db_service.dart';

class SelectTownPage extends ConsumerWidget {
  final int stateId;
  const SelectTownPage({super.key, required this.stateId});

  static const routeName = '/selectTownPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final townsData = ref.watch(townsProvider(stateId));

    return Scaffold(
      appBar: AppBar(title: const Text('İLÇE'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              onChanged: (value) => ref.read(townSearchQueryProvider.notifier).state = value,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-ZığüşöçİĞÜŞÖÇ ]"))],
              decoration: const InputDecoration(
                hintText: 'İlçe...',
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: townsData.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (filteredData) => ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final town = filteredData[index];
                  return ListTile(
                    title: Center(child: Text(town.name ?? '')),
                    onTap: () async {
                      final box = GetStorage();
                      final dbService = DBService();
                      await box.write('townId', town.id);
                      await box.write('townName', town.name);
                      SavedTownModel model = SavedTownModel(townId: town.id, townName: town.name);
                      await dbService.saveTown(model);
                      ref.read(selectedTownIdProvider.notifier).updateTown(town.id!);
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/prayerTimePage',
                          (route) => false,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
