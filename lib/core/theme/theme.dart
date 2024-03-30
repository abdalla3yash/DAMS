import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData theme() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme(),
    primaryColor: const Color(0xFF368CB5),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

AppBarTheme appBarTheme() => const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Color(0xFF368CB5), fontSize: 18),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
