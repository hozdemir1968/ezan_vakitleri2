import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/selected_town_notifier.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  void _checkNavigation() {
    final townId = ref.read(selectedTownIdProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (townId == -1) {
        Navigator.pushReplacementNamed(context, '/selectCountryPage');
      } else {
        Navigator.pushReplacementNamed(context, '/prayerTimePage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
