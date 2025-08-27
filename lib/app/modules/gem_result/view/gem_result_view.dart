import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/core/services/date_formatting_service.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/modules/gem_result/controller/gem_result_controller.dart';
import 'package:gemai/app/modules/gem_result/widgets/value_section_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:gemai/app/modules/gem_result/widgets/temel_tab_widget.dart';
import 'package:gemai/app/modules/gem_result/widgets/kimyasal_tab_widget.dart';
import 'package:gemai/app/modules/gem_result/widgets/astrolojik_tab_widget.dart';
import 'package:gemai/app/modules/gem_result/widgets/top_visual_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';

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
              color: Colors.black.withOpacity(0.05),
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
                                : Colors.transparent,
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

  /// Resim zoom dialog'unu gösterir
  void _showImageZoomDialog(ScanResultModel result) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              // Arka plan - tıklanabilir
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(color: Colors.black.withOpacity(0.8)),
                ),
              ),
              // Resim
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        result.imagePath != null && result.imagePath!.isNotEmpty
                            ? Image.network(
                              result.imagePath!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 300,
                                  height: 300,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                            : Container(
                              width: 300,
                              height: 300,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                ),
              ),
              // Kapat butonu
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
