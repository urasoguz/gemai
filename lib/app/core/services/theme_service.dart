// lib/app/core/theme/theme_service.dart

import 'package:flutter/material.dart';

class ThemeService {
  /// Tek tema kullanıldığı için her zaman light mode döner
  ThemeMode get theme => ThemeMode.light;

  /// Tema değiştirme devre dışı - her zaman false döner
  bool get isDarkMode => false;

  /// Tema değiştirme devre dışı
  void switchTheme() {
    // Tek tema kullanıldığı için tema değiştirme yapılmaz
  }

  /// Belirli bir temaya geçme devre dışı
  void setTheme(bool isDarkMode) {
    // Tek tema kullanıldığı için tema değiştirme yapılmaz
  }

  /// Sistem temasına geçme devre dışı
  void setSystemTheme() {
    // Tek tema kullanıldığı için tema değiştirme yapılmaz
  }
}
