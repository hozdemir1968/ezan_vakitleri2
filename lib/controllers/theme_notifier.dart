import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  final _box = GetStorage();

  @override
  ThemeMode build() {
    final bool? isDarkMode = _box.read('isDarkMode');
    if (isDarkMode == null)
      {
        setTheme(ThemeMode.system);
        return ThemeMode.system;
      }
    else if (isDarkMode) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      _box.write('isDarkMode', false);
    } else {
      state = ThemeMode.dark;
      _box.write('isDarkMode', true);
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    if (mode == ThemeMode.system) {
      _box.remove('isDarkMode');
    } else {
      _box.write('isDarkMode', mode == ThemeMode.dark);
    }
  }
}

//
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
