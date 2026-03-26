import 'package:ezan_vakitleri/components/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/theme_notifier.dart';

class DrawerMenu extends ConsumerWidget {
  final int townId;
  const DrawerMenu({super.key, required this.townId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final bool isDarkMode =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Drawer(
      elevation: 4,
      child: ListView(
        children: [
          Text('MENU', textAlign: TextAlign.center, style: textStyle18B()),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('Günlük Vakitler'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/prayerTimePage', arguments: {'townId': townId});
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_rounded),
            title: Text('Aylık Vakitler'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/prayerTimesPage', arguments: {'townId': townId});
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_location_alt_outlined),
            title: Text('Kayıtlı Konumlar'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/savedTownsPage');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: isDarkMode ? Text('Karanlık') : Text('Aydınlık'),
            trailing: Transform.scale(
              scale: 0.80,
              child: Switch(
                value: isDarkMode,
                onChanged: (bool value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
