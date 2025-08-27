import 'package:flutter/material.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:get/get.dart';

/// Kimyasal tab widget'ı
class KimyasalTabWidget extends StatelessWidget {
  final ScanResultModel data;

  const KimyasalTabWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Fiziksel özellikler
          _buildKimyasalSectionTitle('kimyasal_physical'.tr, Icons.science),
          _buildKimyasalInfoSection(data),
          const SizedBox(height: 16),

          // Kimyasal yapı
          _buildKimyasalSectionTitle(
            'kimyasal_chemical'.tr,
            Icons.science_outlined,
          ),
          _buildChemicalElementsSection(data),
          const SizedBox(height: 16),

          // Kristal özellikler
          _buildKimyasalSectionTitle('kimyasal_crystal'.tr, Icons.diamond),
          _buildCrystalPropertiesSection(data),
          const SizedBox(height: 16),

          // Renk ve parlaklık
          _buildKimyasalSectionTitle('kimyasal_color'.tr, Icons.palette),
          _buildColorAndLusterSection(data),
          const SizedBox(height: 16),

          // Safsızlıklar ve içerikler (DB'den dinamik)
          _buildKimyasalSectionTitle(
            'kimyasal_impurities'.tr,
            Icons.bug_report,
          ),
          _buildImpuritiesSection(data),
          const SizedBox(height: 16),

          // İşleme ve bakım
          _buildKimyasalSectionTitle(
            'kimyasal_processing'.tr,
            Icons.build_circle,
          ),
          _buildProcessingAndCareSection(data),
          const SizedBox(height: 16),

          // Güvenlik
          _buildKimyasalSectionTitle('kimyasal_safety'.tr, Icons.security),
          _buildSafetySection(data),
        ],
      ),
    );
  }

  /// Kimyasal bölüm başlığı
  Widget _buildKimyasalSectionTitle(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppThemeConfig.astroTitleIcon, // Koyu altın renk
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: AppThemeConfig.textPrimary, // Koyu gri
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppThemeConfig.astroDivider, // Altın/bej renk
                  AppThemeConfig.astroDivider.withOpacity(0.3), // Hafif altın
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fiziksel özellikler bölümü
  Widget _buildKimyasalInfoSection(ScanResultModel result) {
    final Map<String, String?> specs = {
      'kimyasal_mohs'.tr: result.mohsHardness?.toString(),
      'kimyasal_crystal_system'.tr: result.crystalSystem,
      'kimyasal_refractive_index'.tr: result.estimatedRefractiveIndex,
      'kimyasal_density'.tr: result.density,
      'kimyasal_magnetism'.tr: result.magnetism,
      'kimyasal_tenacity'.tr: result.tenacity,
    };

    final entries =
        specs.entries.where((e) => (e.value ?? '').isNotEmpty).toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeConfig.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeConfig.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ...entries.asMap().entries.map(
            (entry) => _buildKimyasalInfoCardRow(
              entry.value.key,
              entry.value.value!,
              isLast: entry.key == entries.length - 1,
            ),
          ),
        ],
      ),
    );
  }

  /// Kimyasal elementler bölümü
  Widget _buildChemicalElementsSection(ScanResultModel result) {
    final Map<String, String?> elements = {
      'kimyasal_chemical_classification'.tr: result.chemicalClassification,
      'kimyasal_chemical_formula'.tr: result.chemicalFormula,
      // Kristal Yapı kaldırıldı - Önemli Bilgiler'de zaten var
    };

    final entries =
        elements.entries.where((e) => (e.value ?? '').isNotEmpty).toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeConfig.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeConfig.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ...entries.asMap().entries.map(
            (entry) => _buildKimyasalInfoCardRow(
              entry.value.key,
              entry.value.value!,
              isLast: entry.key == entries.length - 1,
            ),
          ),
        ],
      ),
    );
  }

  /// Kristal özellikler bölümü
  Widget _buildCrystalPropertiesSection(ScanResultModel result) {
    final Map<String, String?> properties = {
      'kimyasal_crystal_system'.tr: result.crystalSystem,
      'kimyasal_cleavage'.tr: result.cleavage,
      'kimyasal_fracture'.tr: result.fracture,
    };

    final entries =
        properties.entries.where((e) => (e.value ?? '').isNotEmpty).toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeConfig.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeConfig.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ...entries.asMap().entries.map(
            (entry) => _buildKimyasalInfoCardRow(
              entry.value.key,
              entry.value.value!,
              isLast: entry.key == entries.length - 1,
            ),
          ),
        ],
      ),
    );
  }

  /// Renk ve parlaklık bölümü
  Widget _buildColorAndLusterSection(ScanResultModel result) {
    return Column(
      children: [
        // Renk spektrumu
        if (result.extendedColorSpectrum != null &&
            result.extendedColorSpectrum!.isNotEmpty)
          _buildColorSpectrumFromBasics(result),
        if (result.extendedColorSpectrum != null &&
            result.extendedColorSpectrum!.isNotEmpty)
          const SizedBox(height: 12),

        // Şeffaflık ve parlaklık
        if (result.transparency != null && result.transparency!.isNotEmpty)
          _buildTransparencySection(result),
        if (result.transparency != null && result.transparency!.isNotEmpty)
          const SizedBox(height: 12),

        if (result.luster != null && result.luster!.isNotEmpty)
          _buildLusterSection(result),
      ],
    );
  }

  /// Yaygın safsızlıklar ve içerikler bölümü (DB'den)
  Widget _buildImpuritiesSection(ScanResultModel result) {
    final List<dynamic> elements = _normalizeListField(result.elements);
    final List<dynamic> impurities = _normalizeListField(
      result.commonImpurities,
    );

    if (elements.isEmpty && impurities.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        if (elements.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppThemeConfig.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppThemeConfig.borderColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'kimyasal_impurities_title'.tr,
                  style: TextStyle(
                    color: AppThemeConfig.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      elements
                          .map((e) => _buildColorChip(e.toString()))
                          .toList(),
                ),
              ],
            ),
          ),
        if (elements.isNotEmpty && impurities.isNotEmpty)
          const SizedBox(height: 12),
        if (impurities.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppThemeConfig.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppThemeConfig.borderColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'kimyasal_impurities_desc'.tr,
                  style: TextStyle(
                    color: AppThemeConfig.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      impurities
                          .map((e) => _buildColorChip(e.toString()))
                          .toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// İşleme ve bakım bölümü
  Widget _buildProcessingAndCareSection(ScanResultModel result) {
    final Map<String, String?> properties = {
      'kimyasal_processing_title'.tr: result.processingDifficulty?.toString(),
      'kimyasal_radioactivity'.tr: result.radioactivity,
    };

    final entries =
        properties.entries.where((e) => (e.value ?? '').isNotEmpty).toList();

    return Column(
      children: [
        // İşleme bilgileri
        if (entries.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppThemeConfig.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppThemeConfig.borderColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                ...entries.asMap().entries.map(
                  (entry) => _buildKimyasalInfoCardRow(
                    entry.value.key,
                    entry.value.value!,
                    isLast: entry.key == entries.length - 1,
                  ),
                ),
              ],
            ),
          ),

        // İşleme ve bakım arası boşluk
        if (entries.isNotEmpty &&
            result.cleaningMaintenanceTips != null &&
            result.cleaningMaintenanceTips!.isNotEmpty)
          const SizedBox(height: 12),

        // Bakım talimatları
        if (result.cleaningMaintenanceTips != null &&
            result.cleaningMaintenanceTips!.isNotEmpty)
          _buildCareSection(result),
      ],
    );
  }

  /// Güvenlik bölümü
  Widget _buildSafetySection(ScanResultModel result) {
    return Column(
      children: [
        // Taklit uyarısı
        if (result.imitationWarning != null &&
            result.imitationWarning!.isNotEmpty)
          _buildImitationWarningFromBasics(result),

        // Taklit uyarısı ve sahte taş belirtileri arası boşluk
        if (result.imitationWarning != null &&
            result.imitationWarning!.isNotEmpty &&
            result.possibleFakeIndicators != null &&
            result.possibleFakeIndicators!.isNotEmpty)
          const SizedBox(height: 12),

        // Sahte taş belirtileri
        if (result.possibleFakeIndicators != null &&
            result.possibleFakeIndicators!.isNotEmpty)
          _buildFakeIndicatorsFromBasics(result),
      ],
    );
  }

  /// Kimyasal bilgi kartı satırı oluşturur - BasicsSectionWidget tasarımına uygun
  Widget _buildKimyasalInfoCardRow(
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppThemeConfig.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  style: TextStyle(
                    color: AppThemeConfig.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) // Son satır değilse ayraç ekle
          Divider(
            height: 1,
            thickness: 0.4,
            color: AppThemeConfig.divider.withOpacity(0.5),
          ),
      ],
    );
  }

  /// Renk spektrumu bölümü (BasicsSectionWidget'tan)
  Widget _buildColorSpectrumFromBasics(ScanResultModel result) {
    final colors = _getColorList(result);
    if (colors.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeConfig.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeConfig.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            colors.map((color) => _buildColorChip(color.toString())).toList(),
      ),
    );
  }

  /// Sahte taş belirtileri (BasicsSectionWidget'tan)
  Widget _buildFakeIndicatorsFromBasics(ScanResultModel result) {
    final indicators = _normalizeFakeIndicatorsField(
      result.possibleFakeIndicators,
    );
    if (indicators.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeConfig.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeConfig.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            indicators
                .map(
                  (indicator) => _buildFakeIndicatorChip(indicator.toString()),
                )
                .toList(),
      ),
    );
  }

  /// Taklit uyarısı (BasicsSectionWidget'tan)
  Widget _buildImitationWarningFromBasics(ScanResultModel result) {
    final warning = result.imitationWarning;
    if (warning == null || warning.toString().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeConfig.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeConfig.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(children: [_buildWarningRow(warning.toString())]),
    );
  }

  // Helper metodlar
  List<dynamic> _getColorList(ScanResultModel result) {
    if (result.extendedColorSpectrum != null &&
        _isValidColorField(result.extendedColorSpectrum)) {
      return _normalizeColorField(result.extendedColorSpectrum);
    }

    if (result.colorSpectrum != null &&
        result.colorSpectrum.toString().isNotEmpty) {
      return result.colorSpectrum
          .toString()
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return [];
  }

  bool _isValidColorField(dynamic value) {
    return value != null && (value is String || value is List);
  }

  List<dynamic> _normalizeColorField(dynamic value) {
    if (value is String) {
      return value.split(',').map((s) => s.trim()).toList();
    }
    if (value is List) {
      return value;
    }
    return [];
  }

  List<dynamic> _normalizeListField(dynamic value) {
    if (value == null) return [];
    if (value is String) return value.split(',').map((s) => s.trim()).toList();
    if (value is List) return value;
    return [];
  }

  List<dynamic> _normalizeFakeIndicatorsField(dynamic value) {
    if (value is String) {
      return value.split(',').map((s) => s.trim()).toList();
    }
    if (value is List) {
      return value;
    }
    return [];
  }

  /// Şeffaflık bölümü
  Widget _buildTransparencySection(ScanResultModel result) {
    final transparencyList = _normalizeTransparencyField(result.transparency);
    if (transparencyList.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeConfig.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeConfig.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'kimyasal_transparency'.tr,
            style: TextStyle(
              color: AppThemeConfig.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                transparencyList
                    .map((item) => _buildColorChip(item.toString()))
                    .toList(),
          ),
        ],
      ),
    );
  }

  /// Parlaklık bölümü
  Widget _buildLusterSection(ScanResultModel result) {
    final lusterList = _normalizeLusterField(result.luster);
    if (lusterList.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeConfig.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeConfig.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'kimyasal_luster'.tr,
            style: TextStyle(
              color: AppThemeConfig.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                lusterList
                    .map((item) => _buildColorChip(item.toString()))
                    .toList(),
          ),
        ],
      ),
    );
  }

  /// Bakım talimatları (CareSectionWidget'tan)
  Widget _buildCareSection(ScanResultModel result) {
    final careInstructions = _normalizeCareInstructionsField(
      result.cleaningMaintenanceTips,
    );
    if (careInstructions.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            careInstructions
                .map(
                  (instruction) =>
                      _buildCareInstructionRow(instruction.toString()),
                )
                .toList(),
      ),
    );
  }

  /// Bakım talimatı satırı oluşturur
  Widget _buildCareInstructionRow(String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppThemeConfig.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: AppThemeConfig.info,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              instruction,
              style: TextStyle(
                color: AppThemeConfig.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Renk chip'i oluşturur
  Widget _buildColorChip(String color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppThemeConfig.astroDivider.withOpacity(
          0.3,
        ), // Hafif altın arka plan
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppThemeConfig.astroDivider.withOpacity(0.5), // Altın border
          width: 1,
        ),
      ),
      child: Text(
        color,
        style: TextStyle(
          color: AppThemeConfig.textPrimary, // Koyu gri metin
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Sahte taş belirtisi chip'i oluşturur
  Widget _buildFakeIndicatorChip(String indicator) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppThemeConfig.error.withOpacity(0.1), // Hafif kırmızı arka plan
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppThemeConfig.error.withOpacity(0.5), // Kırmızı border
          width: 1,
        ),
      ),
      child: Text(
        indicator,
        style: TextStyle(
          color: AppThemeConfig.error, // Koyu kırmızı metin
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Uyarı satırı oluşturur
  Widget _buildWarningRow(String warning) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppThemeConfig.orange.withOpacity(
              0.1,
            ), // Hafif turuncu arka plan
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.warning_amber_rounded,
            color: AppThemeConfig.orange, // Turuncu ikon
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            warning,
            style: TextStyle(
              color: AppThemeConfig.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  List<dynamic> _normalizeTransparencyField(dynamic value) {
    if (value is String) {
      return value.split(',').map((s) => s.trim()).toList();
    }
    if (value is List) {
      return value;
    }
    return [];
  }

  List<dynamic> _normalizeLusterField(dynamic value) {
    if (value is String) {
      return value.split(',').map((s) => s.trim()).toList();
    }
    if (value is List) {
      return value;
    }
    return [];
  }

  List<String> _normalizeCareInstructionsField(dynamic value) {
    if (value is String) {
      return value.split(',').map((s) => s.trim()).toList();
    }
    if (value is List) {
      return value.cast<String>();
    }
    return [];
  }
}
