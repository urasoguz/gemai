import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/modules/legal_warning/controller/legal_warning_controller.dart';

/// Yasal uyarı sayfası - Modern, kompakt ve ekrana sığan tasarım (geri butonu yok)
class LegalWarningView extends StatelessWidget {
  const LegalWarningView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LegalWarningController>();
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    // Dark mode için özel kontrast renkleri
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // İkon ve başlık - kompakt
              Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? colors.primary.withValues(alpha: 0.25)
                              : colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          isDark
                              ? Border.all(
                                color: colors.primary.withValues(alpha: 0.3),
                                width: 1,
                              )
                              : null,
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      color:
                          isDark
                              ? const Color(0xFF71B280) // Daha parlak yeşil
                              : colors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'legal_warning_title'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'legal_warning_subtitle'.tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textSecondary,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // İçerik - kompakt card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDark
                              ? colors.divider.withValues(alpha: 0.3)
                              : colors.divider.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isDark
                                ? Colors.black.withValues(alpha: 0.2)
                                : colors.divider.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Açıklama metinleri
                        _buildDescriptionText(
                          'legal_warning_description_1'.tr,
                          colors,
                        ),
                        const SizedBox(height: 8),
                        _buildDescriptionText(
                          'legal_warning_description_2'.tr,
                          colors,
                        ),
                        const SizedBox(height: 8),
                        _buildDescriptionText(
                          'legal_warning_description_3'.tr,
                          colors,
                        ),

                        const SizedBox(height: 12),

                        // Anlaşma bölümü
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? const Color(
                                      0xFF71B280,
                                    ).withValues(alpha: 0.15)
                                    : colors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isDark
                                      ? const Color(
                                        0xFF71B280,
                                      ).withValues(alpha: 0.4)
                                      : colors.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.gavel_rounded,
                                    color:
                                        isDark
                                            ? const Color(0xFF71B280)
                                            : colors.primary,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'legal_warning_agreement_title'.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildAgreementItem(
                                '1',
                                'legal_warning_agreement_1'.tr,
                                colors,
                              ),
                              _buildAgreementItem(
                                '2',
                                'legal_warning_agreement_2'.tr,
                                colors,
                                onTap: controller.openPrivacyPolicy,
                              ),
                              _buildAgreementItem(
                                '3',
                                'legal_warning_agreement_3'.tr,
                                colors,
                                onTap: controller.openTermsOfService,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Checkbox - kompakt
              Obx(
                () => GestureDetector(
                  onTap: controller.toggleAcceptance,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            controller.isAccepted.value
                                ? (isDark
                                    ? const Color(0xFF71B280)
                                    : colors.primary)
                                : (isDark
                                    ? colors.divider.withValues(alpha: 0.5)
                                    : colors.divider.withValues(alpha: 0.3)),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDark
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : colors.divider.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color:
                                controller.isAccepted.value
                                    ? (isDark
                                        ? const Color(0xFF71B280)
                                        : colors.primary)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color:
                                  controller.isAccepted.value
                                      ? (isDark
                                          ? const Color(0xFF71B280)
                                          : colors.primary)
                                      : (isDark
                                          ? colors.divider.withValues(
                                            alpha: 0.7,
                                          )
                                          : colors.divider.withValues(
                                            alpha: 0.5,
                                          )),
                              width: 1.5,
                            ),
                          ),
                          child:
                              controller.isAccepted.value
                                  ? const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'legal_warning_checkbox_text'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Buton - kompakt
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed:
                        controller.isAccepted.value &&
                                !controller.isLoading.value
                            ? controller.acceptLegalWarning
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.isAccepted.value &&
                                  !controller.isLoading.value
                              ? (isDark
                                  ? const Color(0xFF71B280)
                                  : colors.primary)
                              : (isDark
                                  ? colors.divider.withValues(alpha: 0.4)
                                  : colors.divider.withValues(alpha: 0.3)),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child:
                        controller.isLoading.value
                            ? const CupertinoActivityIndicator(
                              color: Colors.white,
                              radius: 10,
                            )
                            : Text(
                              'legal_warning_confirm_button'.tr,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  /// Açıklama metni widget'ı - kompakt
  Widget _buildDescriptionText(String text, dynamic colors) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.divider.withOpacity(0.08), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: colors.textSecondary,
          height: 1.3,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Anlaşma maddesi widget'ı - kompakt
  Widget _buildAgreementItem(
    String number,
    String text,
    dynamic colors, {
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? colors.surface.withValues(alpha: 0.7) : colors.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color:
              isDark
                  ? colors.divider.withValues(alpha: 0.2)
                  : colors.divider.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color:
                  isDark
                      ? const Color(0xFF71B280).withValues(alpha: 0.25)
                      : colors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border:
                  isDark
                      ? Border.all(
                        color: const Color(0xFF71B280).withValues(alpha: 0.5),
                        width: 0.5,
                      )
                      : null,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF71B280) : colors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child:
                onTap != null
                    ? GestureDetector(
                      onTap: onTap,
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isDark ? const Color(0xFF71B280) : colors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor:
                              isDark ? const Color(0xFF71B280) : colors.primary,
                          decorationThickness: 1.2,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                    : Text(
                      text,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDark
                                ? colors.textPrimary.withValues(alpha: 0.9)
                                : colors.textSecondary,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
