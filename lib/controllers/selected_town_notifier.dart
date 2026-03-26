import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

class SelectedTownNotifier extends Notifier<int> {
  final _box = GetStorage();

  @override
  int build() {
    return _box.read('townId') ?? -1;
  }

  void updateTown(int id) {
    state = id;
    _box.write('townId', id);
  }
}

//
final selectedTownIdProvider = NotifierProvider<SelectedTownNotifier, int>(() {
  return SelectedTownNotifier();
});
