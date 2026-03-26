import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/saved_town_model.dart';
import '../services/db_service.dart';

class SavedTownsNotifier extends AsyncNotifier<List<SavedTownModel>> {
  final _dbService = DBService();

  @override
  Future<List<SavedTownModel>> build() async {
    return await _dbService.getTowns();
  }

  Future<void> deleteTown(int townId) async {
    await _dbService.deleteTownBy(townId);
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _dbService.getTowns());
  }
}

//
final savedTownsProvider = AsyncNotifierProvider<SavedTownsNotifier, List<SavedTownModel>>(
  SavedTownsNotifier.new,
);
