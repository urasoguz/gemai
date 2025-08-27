import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/history/widgets/history_list_item.dart';
import 'package:gemai/app/modules/home/controller/home_controller.dart';

class HomeRecentHistoryWidget extends GetView<HomeController> {
  HomeRecentHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Başlık için Expanded kullan - taşmayı engeller
              Expanded(
                child: Text(
                  'home_recent_history_title'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppThemeConfig.textPrimary,
                  ),
                  // Uzun metinler için overflow kontrolü
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8), // Başlık ve buton arasında boşluk
              // Buton için Flexible kullan - gerektiğinde küçülür
              Flexible(
                child: TextButton(
                  onPressed: () {
                    // Geçmiş sekmesine geç
                    controller.changeTab(1);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppThemeConfig.textLink,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // 👇  Efektleri kaldıran satırlar
                    overlayColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Text(
                    'home_recent_history_view_more'.tr,
                    // Buton metni için overflow kontrolü
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GetBuilder<HomeController>(
          builder: (controller) {
            final items = controller.recentItems;
            if (items.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  'home_recent_history_no_history'.tr,
                  style: TextStyle(
                    color: AppThemeConfig.textSecondary,
                    fontSize: 14,
                  ),
                ),
              );
            }
            return Column(
              children: List.generate(
                items.length > 2 ? 2 : items.length,
                (i) => HistoryListItem(
                  item: items[i],
                  index: i,
                  onTap: () {
                    Get.toNamed(AppRoutes.gemResult, arguments: items[i].id);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
