import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/services/sembast_service.dart';
import 'package:gemai/app/core/services/date_formatting_service.dart';
import 'package:gemai/app/modules/result/widgets/result_image_widget.dart';
import 'package:gemai/app/modules/history/controller/history_controller.dart';
import 'package:gemai/app/modules/home/controller/home_controller.dart';
import 'package:flutter/foundation.dart';

class HistoryListItem extends StatelessWidget {
  final HistoryItem item;
  final int index;
  final VoidCallback onTap;
  const HistoryListItem({
    super.key,
    required this.item,
    required this.index,
    required this.onTap,
  });

  // Nadirlik rozetini oluşturur (altın palet)
  Widget _rarityPill(int? score) {
    final int s = (score ?? 0).clamp(0, 10);
    String label;
    if (s >= 9) {
      label = 'top_visual_rarity_desc_1'.tr;
    } else if (s >= 7) {
      label = 'top_visual_rarity_desc_2'.tr;
    } else if (s >= 4) {
      label = 'top_visual_rarity_desc_3'.tr;
    } else {
      label = 'top_visual_rarity_desc_4'.tr;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppThemeConfig.astroDivider.withOpacity(0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppThemeConfig.astroDivider, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: 12,
            color: AppThemeConfig.astroTitleIcon,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: AppThemeConfig.textPrimary,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = item.model;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Material(
        color: AppThemeConfig.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor: AppThemeConfig.divider.withOpacity(0.06),
          highlightColor: AppThemeConfig.divider.withOpacity(0.03),
          child: Container(
            decoration: BoxDecoration(
              color: AppThemeConfig.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppThemeConfig.astroDivider, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppThemeConfig.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 56,
                    height: 56,
                    color: AppThemeConfig.card,
                    child:
                        model.imagePath != null && model.imagePath!.isNotEmpty
                            ? ResultImageWidget(
                              imagePath: model.imagePath,
                              width: 56,
                              height: 56,
                              borderRadius: 10,
                              margin: EdgeInsets.zero,
                              model: model,
                            )
                            : Icon(
                              Icons.image,
                              size: 22,
                              color: AppThemeConfig.textHint,
                            ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        model.type ?? '-',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppThemeConfig.textPrimary,
                          letterSpacing: 0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _rarityPill(model.rarityScore),
                          if (model.valuePerCarat != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppThemeConfig.valueHighlight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppThemeConfig.astroDivider,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    size: 12,
                                    color: AppThemeConfig.astroTitleIcon,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    model.valuePerCarat!.toStringAsFixed(0),
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: AppThemeConfig.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (model.createdAt != null)
                            FutureBuilder<String>(
                              future: _getFormattedDate(model.createdAt!),
                              builder: (context, snapshot) {
                                if (kDebugMode) {
                                  print(
                                    '🔍 HistoryListItem - Tarih formatlanıyor: ${model.createdAt}',
                                  );
                                  print(
                                    '🔍 HistoryListItem - Snapshot durumu: ${snapshot.connectionState}',
                                  );
                                  if (snapshot.hasError) {
                                    print(
                                      '❌ HistoryListItem - Snapshot hatası: ${snapshot.error}',
                                    );
                                  }
                                }

                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: AppThemeConfig.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }
                                if (snapshot.hasError) {
                                  if (kDebugMode) {
                                    print(
                                      '❌ HistoryListItem - Tarih formatlanamadı: ${snapshot.error}',
                                    );
                                  }
                                  // Hata durumunda basit tarih göster
                                  return Text(
                                    '${model.createdAt!.day}/${model.createdAt!.month}/${model.createdAt!.year}',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: AppThemeConfig.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                // Favori butonu
                GestureDetector(
                  onTap: () async {
                    final historyController = Get.find<HistoryController>();
                    await historyController.toggleFavorite(item.id);

                    // HomeController'ı da güncelle (eğer mevcut ise)
                    try {
                      if (Get.isRegistered<HomeController>()) {
                        final homeController = Get.find<HomeController>();
                        await homeController.loadRecentItems();
                        if (kDebugMode) {
                          print(
                            '✅ HistoryListItem - HomeController güncellendi',
                          );
                        }
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(
                          '⚠️ HistoryListItem - HomeController güncellenemedi: $e',
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color:
                          (model.isFavorite ?? false)
                              ? AppThemeConfig.error.withOpacity(0.15)
                              : AppThemeConfig.divider.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            (model.isFavorite ?? false)
                                ? AppThemeConfig.error.withOpacity(0.3)
                                : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      (model.isFavorite ?? false)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 16,
                      color:
                          (model.isFavorite ?? false)
                              ? AppThemeConfig.error
                              : AppThemeConfig.textHint,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppThemeConfig.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tarih formatlaması için yardımcı metod
  Future<String> _getFormattedDate(DateTime dateTime) async {
    try {
      if (Get.isRegistered<DateFormattingService>()) {
        final dateService = Get.find<DateFormattingService>();
        return await dateService.formatRelativeDate(dateTime);
      } else {
        if (kDebugMode) {
          print(
            '⚠️ HistoryListItem - DateFormattingService bulunamadı, basit format kullanılıyor',
          );
        }
        // DateFormattingService bulunamazsa basit format kullan
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ HistoryListItem - Tarih formatlanamadı: $e');
      }
      // Hata durumunda basit format kullan
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
