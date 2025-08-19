import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  const HomeBottomNavBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Tema renklerini al
    final colors =
        AppThemeConfig.colors;

    return BottomAppBar(
      color: colors.bottomNav,
      elevation: 0,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => onTabSelected(0),
                onLongPress: () {
                  // Uzun basınca örnek: tooltip göster
                  final tooltip = Tooltip(
                    message: 'home'.tr,
                    child: Container(),
                  );
                  final entry = OverlayEntry(builder: (_) => tooltip);
                  Overlay.of(context).insert(entry);
                  Future.delayed(const Duration(seconds: 1), entry.remove);
                },
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.transparent, // 💧 Splash efekt kapalı
                highlightColor: Colors.transparent, // ☀️ Highlight efekt kapalı
                hoverColor:
                    Colors.transparent, // (isteğe bağlı) Hover efekt kapalı
                focusColor:
                    Colors.transparent, // (isteğe bağlı) Focus efekti kapalı
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color:
                          selectedTab == 0
                              ? colors.textLink
                              : colors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'home'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            selectedTab == 0
                                ? colors.textLink
                                : colors.textSecondary,
                        fontWeight:
                            selectedTab == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 64), // Ortadaki kamera butonu için boşluk
            Expanded(
              child: InkWell(
                onTap: () => onTabSelected(1),
                onLongPress: () {
                  // Uzun basınca örnek: tooltip göster
                  final tooltip = Tooltip(
                    message: 'history'.tr,
                    child: Container(),
                  );
                  final entry = OverlayEntry(builder: (_) => tooltip);
                  Overlay.of(context).insert(entry);
                  Future.delayed(const Duration(seconds: 1), entry.remove);
                },
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.transparent, // 💧 Splash efekt kapalı
                highlightColor: Colors.transparent, // ☀️ Highlight efekt kapalı
                hoverColor:
                    Colors.transparent, // (isteğe bağlı) Hover efekt kapalı
                focusColor:
                    Colors.transparent, // (isteğe bağlı) Focus efekti kapalı
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      color:
                          selectedTab == 1
                              ? colors.textLink
                              : colors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'history'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            selectedTab == 1
                                ? colors.textLink
                                : colors.textSecondary,
                        fontWeight:
                            selectedTab == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
