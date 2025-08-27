import 'package:gemai/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import '../controller/history_controller.dart';
import '../widgets/history_list_item.dart';

class HistoryView extends StatelessWidget {
  HistoryView({super.key});
  final controller = Get.put(HistoryController());
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Üst bardaki sistem metinlerini siyah yap (history için)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Status bar şeffaf
        statusBarIconBrightness: Brightness.dark, // Status bar ikonları siyah
        statusBarBrightness: Brightness.light, // iOS için status bar açık tema
        systemNavigationBarColor: Colors.transparent, // Alt navigasyon şeffaf
        systemNavigationBarIconBrightness:
            Brightness.dark, // Alt navigasyon ikonları koyu
      ),
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        controller.fetchNextPage();
      }
    });

    return Column(
      children: [
        // Sekme kontrolü (Tümü / Favoriler)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppThemeConfig.divider.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(
            () => Row(
              children: [
                // Tümü Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.changeTab(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            controller.selectedTab.value == 0
                                ? AppThemeConfig.background
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:
                            controller.selectedTab.value == 0
                                ? [
                                  BoxShadow(
                                    color: AppThemeConfig.divider.withOpacity(
                                      0.2,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          'history_all'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                controller.selectedTab.value == 0
                                    ? AppThemeConfig.textLink
                                    : AppThemeConfig.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Favoriler Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.changeTab(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            controller.selectedTab.value == 1
                                ? AppThemeConfig.background
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:
                            controller.selectedTab.value == 1
                                ? [
                                  BoxShadow(
                                    color: AppThemeConfig.divider.withOpacity(
                                      0.2,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          'history_favorites'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                controller.selectedTab.value == 1
                                    ? AppThemeConfig.textLink
                                    : AppThemeConfig.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // İçerik - PageView ile sağa/sola kaydırarak tab geçişi
        Expanded(
          child: Obx(
            () => PageView(
              controller: controller.pageController,
              onPageChanged: (int index) {
                controller.selectedTab.value = index;
              },
              children: [
                // Tümü tab - tüm geçmiş
                RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshHistory();
                  },
                  child: _buildHistoryList(),
                ),
                // Favoriler tab - sadece favoriler
                RefreshIndicator(
                  onRefresh: () async {
                    await controller.loadFavorites();
                  },
                  child: _buildFavoritesList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Tüm geçmiş listesini oluşturur
  Widget _buildHistoryList() {
    if (controller.items.isEmpty && controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppThemeConfig.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'history_no_history'.tr,
              style: TextStyle(
                fontSize: 16,
                color: AppThemeConfig.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: controller.items.length + (controller.hasMore.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const SizedBox(
                height: 2,
              ), // Tümü listesi ile aynı boşluk - azaltıldı
              HistoryListItem(
                item: controller.items[index],
                index: index,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.gemResult,
                    arguments: controller.items[index].id,
                  );
                },
              ),
            ],
          );
        }
        if (index < controller.items.length) {
          final item = controller.items[index];
          return HistoryListItem(
            item: item,
            index: index,
            onTap: () {
              Get.toNamed(AppRoutes.gemResult, arguments: item.id);
            },
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  /// Favoriler listesini oluşturur
  Widget _buildFavoritesList() {
    if (controller.favoriteItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: AppThemeConfig.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'history_no_favorites'.tr,
              style: TextStyle(
                fontSize: 16,
                color: AppThemeConfig.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.favoriteItems.length,
      itemBuilder: (context, index) {
        final item = controller.favoriteItems[index];
        if (index == 0) {
          return Column(
            children: [
              const SizedBox(
                height: 2,
              ), // Tümü listesi ile aynı boşluk - azaltıldı
              HistoryListItem(
                item: item,
                index: index,
                onTap: () {
                  Get.toNamed(AppRoutes.gemResult, arguments: item.id);
                },
              ),
            ],
          );
        }
        return HistoryListItem(
          item: item,
          index: index,
          onTap: () {
            Get.toNamed(AppRoutes.gemResult, arguments: item.id);
          },
        );
      },
    );
  }
}
