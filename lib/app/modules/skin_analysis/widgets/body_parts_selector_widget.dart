import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/modules/skin_analysis/controller/skin_analysis_controller.dart';

/// Vücut bölgeleri seçici widget'ı
/// Chip'ler ile çoklu seçim
class BodyPartsSelectorWidget extends GetView<SkinAnalysisController> {
  const BodyPartsSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.colors;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'skin_analysis_body_parts'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),

          // Chip'ler
          Obx(
            () => Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  controller.bodyParts.map((String bodyPart) {
                    final isSelected = controller.selectedBodyParts.contains(
                      bodyPart,
                    );
                    return GestureDetector(
                      onTap:
                          controller.isAnalyzing.value
                              ? null
                              : () => controller.toggleBodyPart(bodyPart),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? colors.gradientSecondary
                                  : colors.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                isSelected
                                    ? colors.gradientSecondary
                                    : colors.divider,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  isSelected
                                      ? colors.gradientSecondary.withValues(
                                        alpha: 0.3,
                                      )
                                      : colors.buttonShadow.withValues(
                                        alpha: 0.05,
                                      ),
                              blurRadius: isSelected ? 8 : 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          bodyPart,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected
                                    ? colors.buttonIcon
                                    : colors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          // Seçim sayısı
          Obx(() {
            if (controller.selectedBodyParts.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '${controller.selectedBodyParts.length} ${'skin_analysis_body_parts_selected'.tr}',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.gradientSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
