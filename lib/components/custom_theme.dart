import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  fontFamily: 'Roboto',
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  fontFamily: 'Roboto',
);

//TEXTSTYLE
TextStyle textStyle16() => const TextStyle(fontSize: 16);
TextStyle textStyle16B() => TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
TextStyle textStyle18() => const TextStyle(fontSize: 18);
TextStyle textStyle18B() => TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
TextStyle textStyle18BT() =>
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal);
TextStyle textStyle18BO() =>
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange);
TextStyle textStyle19() => const TextStyle(fontSize: 19);
TextStyle textStyle19B() => TextStyle(fontSize: 19, fontWeight: FontWeight.bold);
TextStyle textStyle19BT() =>
    TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.teal);
TextStyle textStyle19O() => TextStyle(fontSize: 19, color: Colors.deepOrange);
TextStyle textStyle19BO() =>
    TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.deepOrange);
TextStyle textStyle20() => TextStyle(fontSize: 20);
TextStyle textStyle20B() => TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
TextStyle textStyle20BO() =>
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange);
TextStyle textStyle20BT() =>
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal);
TextStyle textStyle20T() => TextStyle(fontSize: 20, color: Colors.teal);
TextStyle textStyle20O() => TextStyle(fontSize: 20, color: Colors.deepOrange);
TextStyle textStyle22B() => TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
TextStyle textStyle24B() => TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
TextStyle textStyle26B() => TextStyle(fontSize: 26, fontWeight: FontWeight.bold);
