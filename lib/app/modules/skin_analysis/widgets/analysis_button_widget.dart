import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/modules/skin_analysis/controller/skin_analysis_controller.dart';

/// Analiz butonu widget'ı
/// Gradient buton ile analizi başlatır
class AnalysisButtonWidget extends GetView<SkinAnalysisController> {
  const AnalysisButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.primary;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Obx(
        () => GestureDetector(
          onTap:
              (controller.isLoading.value || controller.isAnalyzing.value)
                  ? null
                  : controller.startAnalysis,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors:
                    controller.isLoading.value
                        ? [colors.divider, colors.divider]
                        : [colors.gradientPrimary, colors.gradientSecondary],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      controller.isLoading.value
                          ? colors.buttonShadow.withValues(alpha: 0.3)
                          : colors.gradientSecondary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child:
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: colors.buttonText,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'skin_analysis_button_title_loading'.tr,
                            style: TextStyle(
                              color: colors.buttonText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                      : Text(
                        'skin_analysis_button_title'.tr,
                        style: TextStyle(
                          color: colors.buttonText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
