import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/saved_town_notifier.dart';
import '../controllers/selected_town_notifier.dart';
import '../models/saved_town_model.dart';

class SavedTownsPage extends ConsumerWidget {
  const SavedTownsPage({super.key});

  static const routeName = '/savedTownsPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedTownsAsync = ref.watch(savedTownsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kayıtlı Konumlar'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () => ref.read(savedTownsProvider.notifier).refresh(),
        child: savedTownsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Hata: $err')),
          data: (townList) {
            if (townList.isEmpty) {
              return const Center(child: Text('Kayıtlı Konum Yok'));
            }
            return ListView.builder(
              itemCount: townList.length,
              itemBuilder: (context, index) {
                final town = townList[index];
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(town.townName ?? ''),
                      trailing: Text(town.townId.toString()),
                      onTap: () {
                        ref.read(selectedTownIdProvider.notifier).updateTown(town.townId!);
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      },
                      onLongPress: () => _showDeleteDialog(context, ref, town),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(selectedTownIdProvider.notifier).updateTown(-1);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, SavedTownModel town) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dikkat !'),
        content: Text('${town.townName} silinsin mi?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('HAYIR')),
          TextButton(
            onPressed: () async {
              await ref.read(savedTownsProvider.notifier).deleteTown(town.townId!);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('EVET'),
          ),
        ],
      ),
    );
  }
}
