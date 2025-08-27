import 'package:flutter/material.dart';

class AppColors {
  final Color appBarColor;
  final Color backgroundColor;
  final Color textColor;

  static const Color lightAppBar = Colors.red;
  static const Color darkAppBar = Colors.blue;
  static const Color lightBackground = Colors.white;
  static const Color darkBackground = Colors.black;

  // Primary renk ekledim
  static const Color primary = Color(0xFF2196F3);

  AppColors({
    required this.appBarColor,
    required this.backgroundColor,
    required this.textColor,
  });

  // Light tema renkleri
  static final AppColors light = AppColors(
    appBarColor: Colors.red,
    backgroundColor: Colors.white,
    textColor: Colors.black,
  );

  // Dark tema renkleri
  static final AppColors dark = AppColors(
    appBarColor: Colors.blue,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );

  // context'e göre doğru temayı al
  static AppColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }
}
