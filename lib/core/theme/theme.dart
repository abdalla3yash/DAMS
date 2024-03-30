import 'package:dams/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData theme() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: appBarTheme(),
    primaryColor: AppColors.primary,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: const IconThemeData(color:AppColors.primary,size: 128),
  );

AppBarTheme appBarTheme() => const AppBarTheme(
    color: AppColors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.white),
    titleTextStyle: TextStyle(color: AppColors.primary, fontSize: 18),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
