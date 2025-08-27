import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:gemai/app/modules/gem_result/controller/gem_result_controller.dart';
import 'package:gemai/app/modules/gem_result/widgets/value_section_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:gemai/app/modules/gem_result/widgets/temel_tab_widget.dart';
import 'package:gemai/app/modules/gem_result/widgets/kimyasal_tab_widget.dart';
import 'package:gemai/app/modules/gem_result/widgets/astrolojik_tab_widget.dart';
import 'package:gemai/app/modules/gem_result/widgets/top_visual_widget.dart';

/// GemAI sonuç sayfası
/// - Taş analiz sonuçlarını detaylı şekilde gösterir
/// - Sekmeli yapı ile organize edilmiş içerik
/// - Premium kilitli alanlar
class GemResultView extends GetView<GemResultController> {
  const GemResultView({super.key});

  @override
  Widget build(BuildContext context) {
    // Paylaşım için GlobalKey
    final GlobalKey shareKey = GlobalKey();

    return Scaffold(
      backgroundColor: AppThemeConfig.background,
      body: Obx(() {
        final result = controller.result.value;
        if (result == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RepaintBoundary(
          key: shareKey, // Paylaşım için key
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(), // Yukarı çekilemesin
            child: Column(
              children: [
                // Top visual area - foto üste kadar sabit, scroll ile yukarı kayar
                TopVisualWidget(shareKey: shareKey),

                // Tab Bar - sabit
                _buildTabBar(),

                // Tab içerikleri - scroll edilebilir
                _buildActiveTab(result),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Tab bar'ı oluşturur - eski tasarım kopyalandı
  Widget _buildTabBar() {
    return Obx(() {
      return Container(
        // padding kaldırıldı - tam alan kaplama için
        decoration: BoxDecoration(
          color: AppThemeConfig.background,
          border: Border(
            bottom: BorderSide(
              color: AppThemeConfig.divider.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppThemeConfig.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Sağa sola yasla
          children: List.generate(controller.sectionTitles.length, (int i) {
            final bool selected = controller.activeTabIndex.value == i;
            return Expanded(
              // Her tab'ı eşit genişlikte yap
              child: GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    print(
                      '🔄 Tab tıklandı: $i - ${controller.sectionTitles[i]}',
                    );
                  }
                  // Tab'a tıklandığında sadece seçili tab'ı güncelle
                  controller.activeTabIndex.value = i;
                },
                child: Container(
                  // margin ve padding kaldırıldı - tam alan kaplama için
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 0, // Yatay padding sıfırlandı
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            selected
                                ? AppThemeConfig.gradientSecondary
                                : AppThemeConfig.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    controller.sectionTitles[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color:
                          selected
                              ? AppThemeConfig.gradientSecondary
                              : AppThemeConfig.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  /// Aktif tab'ın içeriğini oluşturur
  Widget _buildActiveTab(ScanResultModel result) {
    return Obx(() {
      switch (controller.activeTabIndex.value) {
        case 0:
          return TemelTabWidget(data: result);
        case 1:
          return ValueSectionWidget(data: result);
        case 2:
          return KimyasalTabWidget(data: result);
        case 3:
          return AstrolojikTabWidget(data: result);
        default:
          return TemelTabWidget(data: result);
      }
    });
  }
}
