import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/shared/widgets/modular_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import '../controller/result_controller.dart';
import '../widgets/result_image_widget.dart';
import '../widgets/severity_indicator_widget.dart';
import '../widgets/result_info_card.dart';
import '../widgets/result_chip_card.dart';
import '../widgets/result_description_card.dart';
import '../widgets/result_footer_note.dart';
import '../widgets/result_reference_card.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: ModularAppBar(
        title: 'result_title'.tr,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 30),
          onPressed: () => Get.back(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashRadius: 0.1,
          enableFeedback: false,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.share_rounded, size: 24),
          onPressed: () => _shareResult(context),
          tooltip: 'share_result_title'.tr,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value || controller.result.value == null) {
          return Center(child: Text('result_no_result'.tr));
        }

        final result = controller.result.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Büyük görsel, gölgeli ve radiuslu
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colors.buttonShadow.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ResultImageWidget(
                    imagePath: result.imagePath,
                    width: 160,
                    height: 110,
                    borderRadius: 16,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                  ),
                ),
              ),

              // 2. Bilgi kartları (her biri ayrı kutu)
              ResultInfoCard(
                title: 'result_disease_name'.tr,
                value: result.name ?? '-',
                icon: Icons.medical_services_rounded,
              ),

              // Açıklama kutusu
              if (result.description != null && result.description!.isNotEmpty)
                ResultDescriptionCard(description: result.description!),

              // Bulaşıcı mı ve Şiddet yan yana
              Row(
                children: [
                  // Bulaşıcı mı kartı
                  Expanded(
                    child: ResultInfoCard(
                      title: 'result_contagious'.tr,
                      value: result.contagious ?? '-',
                      icon: Icons.verified_user_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Şiddet kartı
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.divider, width: 0.7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                size: 18,
                                color: colors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'result_severity'.tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.textTertiary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          SeverityIndicatorWidget(
                            value:
                                int.tryParse(result.severityRatio ?? "3") ?? 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              ResultInfoCard(
                title: 'result_recovery_time'.tr,
                value: result.recoveryTime ?? '-',
                icon: Icons.timer_rounded,
              ),

              // Chip kartları
              ResultChipCard(
                title: 'result_symptoms'.tr,
                items: result.symptoms ?? [],
                chipColor: colors.symptomChipColor,
              ),
              ResultChipCard(
                title: 'result_body_parts'.tr,
                items: result.bodyParts ?? [],
                chipColor: colors.bodyPartChipColor,
              ),
              ResultChipCard(
                title: 'result_risk_factors'.tr,
                items: result.riskFactors ?? [],
                chipColor: colors.riskFactorChipColor,
              ),
              ResultChipCard(
                title: 'result_treatment'.tr,
                items: result.treatment ?? [],
                chipColor: colors.treatmentChipColor,
              ),
              ResultChipCard(
                title: 'result_prevention'.tr,
                items: result.prevention ?? [],
                chipColor: colors.preventionChipColor,
              ),
              ResultChipCard(
                title: 'result_alternative_treatment'.tr,
                items: result.alternativeTreatments ?? [],
                chipColor: colors.alternativeTreatmentChipColor,
              ),

              // Reference card'ı
              if (result.reference != null) ...[
                const SizedBox(height: 10),
                ResultReferenceCard(reference: result.reference!),
                const SizedBox(height: 10),
              ],

              // Footer notu
              ResultFooterNote(),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // Tüm result sayfasının ekran görüntüsünü alır ve paylaşır
  Future<void> _shareResult(BuildContext context) async {
    try {
      final colors =
          AppThemeConfig.colors;

      final result = controller.result.value!;

      // captureFromLongWidget ile uzun içeriği yakala - TAM ÇÖZÜM!
      final ScreenshotController screenshotController = ScreenshotController();
      final Uint8List
      imageBytes = await screenshotController.captureFromLongWidget(
        InheritedTheme.captureAll(
          context,
          Material(
            color: colors.background,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Büyük görsel
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colors.buttonShadow.withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ResultImageWidget(
                        imagePath: result.imagePath,
                        width: 160,
                        height: 110,
                        borderRadius: 16,
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                      ),
                    ),
                  ),

                  // 2. Bilgi kartları
                  ResultInfoCard(
                    title: 'result_disease_name'.tr,
                    value: result.name ?? '-',
                    icon: Icons.medical_services_rounded,
                  ),

                  // Açıklama kutusu
                  if (result.description != null &&
                      result.description!.isNotEmpty)
                    ResultDescriptionCard(description: result.description!),

                  // Bulaşıcı mı ve Şiddet yan yana
                  Row(
                    children: [
                      Expanded(
                        child: ResultInfoCard(
                          title: 'result_contagious'.tr,
                          value: result.contagious ?? '-',
                          icon: Icons.verified_user_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: colors.divider,
                              width: 0.7,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_fire_department_rounded,
                                    size: 18,
                                    color: colors.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'result_severity'.tr,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colors.textTertiary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              SeverityIndicatorWidget(
                                value:
                                    int.tryParse(result.severityRatio ?? "3") ??
                                    3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  ResultInfoCard(
                    title: 'result_recovery_time'.tr,
                    value: result.recoveryTime ?? '-',
                    icon: Icons.timer_rounded,
                  ),

                  // Chip kartları
                  ResultChipCard(
                    title: 'result_symptoms'.tr,
                    items: result.symptoms ?? [],
                    chipColor: colors.symptomChipColor,
                  ),
                  ResultChipCard(
                    title: 'result_body_parts'.tr,
                    items: result.bodyParts ?? [],
                    chipColor: colors.bodyPartChipColor,
                  ),
                  ResultChipCard(
                    title: 'result_risk_factors'.tr,
                    items: result.riskFactors ?? [],
                    chipColor: colors.riskFactorChipColor,
                  ),
                  ResultChipCard(
                    title: 'result_treatment'.tr,
                    items: result.treatment ?? [],
                    chipColor: colors.treatmentChipColor,
                  ),
                  ResultChipCard(
                    title: 'result_prevention'.tr,
                    items: result.prevention ?? [],
                    chipColor: colors.preventionChipColor,
                  ),
                  ResultChipCard(
                    title: 'result_alternative_treatment'.tr,
                    items: result.alternativeTreatments ?? [],
                    chipColor: colors.alternativeTreatmentChipColor,
                  ),

                  // Reference card'ı
                  if (result.reference != null) ...[
                    const SizedBox(height: 10),
                    ResultReferenceCard(reference: result.reference!),
                    const SizedBox(height: 10),
                  ],

                  // Footer notu
                  ResultFooterNote(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        delay: const Duration(milliseconds: 100),
        context: context,
      );

      // Geçici dosya oluştur
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName =
          'dermai_result_${DateTime.now().millisecondsSinceEpoch}.png';
      final File tempFile = File('${tempDir.path}/$fileName');

      // Dosyaya kaydet
      await tempFile.writeAsBytes(imageBytes);

      // Paylaşım menüsünü göster
      await Share.shareXFiles([
        XFile(tempFile.path),
      ], text: 'share_result_share_text'.tr);

      // Geçici dosyayı sil
      await tempFile.delete();
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi ver
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'share_result_error'.tr} $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
