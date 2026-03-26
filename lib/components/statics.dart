import 'package:flutter/material.dart';

final baseUrl = 'https://j2b9dc7n53.execute-api.us-east-1.amazonaws.com/dev/';
const String countriesEP = "countries";
const String statesEP = "states";
const String townsEP = "towns";
const String prayerTimeEP = "prayertimes";
const String dailyEP = "daily";

final vakits = ['İmsak', 'Güneş', 'Öğlen', 'İkindi', 'Akşam', 'Yatsı'];
final vakite = ['İmsağa', 'Güneşe', 'Öğlene', 'İkindiye', 'Akşama', 'Yatsıya', 'İmsağa'];

final themes = ['System', 'Light', 'Dark'];

final trTR = Locale('tr', 'TR');

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
