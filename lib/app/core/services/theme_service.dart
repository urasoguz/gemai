// lib/app/core/theme/theme_service.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';

class ThemeService {
  final _box = GetStorage();

  // MyHelper ile uyumlu storage key kullan
  final _key = MyHelper.isDarkMode;

  /// Mevcut tema modunu döner
  ThemeMode get theme {
    final savedTheme = _loadThemeFromBox();
    if (savedTheme == null) {
      // İlk yükleme - sistem temasını kullan
      //return _getSystemTheme();
      // İlk yükleme - varsayılan olarak light mode kullan
      return ThemeMode.light;
    }
    return savedTheme ? ThemeMode.dark : ThemeMode.light;
  }

  /// Sistem temasını algılar
  ThemeMode _getSystemTheme() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }

  /// Kaydedilmiş tema ayarını yükler
  /// null: İlk yükleme (sistem teması kullanılacak)
  /// true: Dark mode
  /// false: Light mode
  bool? _loadThemeFromBox() => _box.read(_key);

  /// Temayı kaydeder
  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  /// Tema değiştirir
  void switchTheme() {
    final currentTheme = _loadThemeFromBox();
    // İlk geçişte light'tan dark'a, sonrasında toggle
    final newTheme = currentTheme == null ? true : !currentTheme;

    _saveThemeToBox(newTheme);
    Get.changeThemeMode(newTheme ? ThemeMode.dark : ThemeMode.light);
  }

  /// Belirli bir temaya geçer
  void setTheme(bool isDarkMode) {
    _saveThemeToBox(isDarkMode);
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  /// Sistem temasına geçer
  void setSystemTheme() {
    _box.remove(_key); // Kaydedilmiş ayarı sil
    final systemTheme = _getSystemTheme();
    Get.changeThemeMode(systemTheme);
  }

  /// Mevcut tema durumunu döner
  bool get isDarkMode {
    final savedTheme = _loadThemeFromBox();
    if (savedTheme == null) {
      // İlk yükleme - sistem temasını kontrol et
      //return _getSystemTheme() == ThemeMode.dark;
      // İlk yükleme - varsayılan olarak light mode
      return false;
    }
    return savedTheme;
  }
}
