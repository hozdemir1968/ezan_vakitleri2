import 'package:flutter/material.dart';

import '../ui/prayer_time_page.dart';
import '../ui/prayer_times_page.dart';
import '../ui/saved_towns_page.dart';
import '../ui/select_country_page.dart';
import '../ui/select_state_page.dart';
import '../ui/select_town_page.dart';
import '../ui/splash_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case '/selectCountryPage':
        return MaterialPageRoute(builder: (_) => const SelectCountryPage());

      case '/selectStatePage':
        final args = settings.arguments as Map<String, dynamic>;
        final countryId = args['countryId'];
        return MaterialPageRoute(builder: (context) => SelectStatePage(countryId: countryId));

      case '/selectTownPage':
        final args = settings.arguments as Map<String, dynamic>;
        final stateId = args['stateId'];
        return MaterialPageRoute(builder: (context) => SelectTownPage(stateId: stateId));

      case '/prayerTimePage':
        return MaterialPageRoute(builder: (context) => PrayerTimePage());

      case '/prayerTimesPage':
        return MaterialPageRoute(builder: (context) => PrayerTimesPage());

      case '/savedTownsPage':
        return MaterialPageRoute(builder: (_) => const SavedTownsPage());

      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
