import 'package:flutter/material.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:gemai/app/modules/gem_result/widgets/basics_section_widget.dart';
import 'package:get/get.dart';

/// Temel tab widget'ı
class TemelTabWidget extends StatelessWidget {
  final ScanResultModel data;

  const TemelTabWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BasicsSectionWidget(data: data),
        const SizedBox(height: 16),

        // Kullanım alanları
        if (data.uses != null && _isValidUsesField(data.uses))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildTemelSectionTitle('basics_uses'.tr, Icons.build),
          ),
        if (data.uses != null && _isValidUsesField(data.uses))
          _buildTemelInfoSection(_normalizeUsesField(data.uses)),
        if (data.uses != null && _isValidUsesField(data.uses))
          const SizedBox(height: 16),

        // Formasyon ve yaş
        if (data.formation != null && data.formation.toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildTemelSectionTitle(
              'basics_formation'.tr,
              Icons.timeline,
            ),
          ),
        if (data.formation != null && data.formation.toString().isNotEmpty)
          _buildTemelInfoSection([data.formation.toString()]),
        if (data.formation != null && data.formation.toString().isNotEmpty)
          const SizedBox(height: 12),
        if (data.ageDescription != null &&
            data.ageDescription.toString().isNotEmpty)
          _buildTemelInfoSection([data.ageDescription.toString()]),

        // En alta uyarı notu
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildDisclaimerNote(),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  /// Temel bölüm başlığı
  Widget _buildTemelSectionTitle(String title, IconData icon) {
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

  /// Temel bilgi bölümü
  Widget _buildTemelInfoSection(List<dynamic> items) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
        children:
            items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      item.toString(), // dynamic değeri String'e çevir
                      style: TextStyle(
                        color: AppThemeConfig.textPrimary,
                        fontSize: 13.5,
                        height: 1.5,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  // Uyarı notu: Temel tabın en altı
  Widget _buildDisclaimerNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemeConfig.disclaimerBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppThemeConfig.disclaimerBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppThemeConfig.disclaimerBorder,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.info_outline,
              size: 16,
              color: AppThemeConfig.panelBorderBrown,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'basics_disclaimer'.tr,
              style: TextStyle(
                color: AppThemeConfig.disclaimerTextBrown,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidUsesField(dynamic value) {
    return value != null && (value is String || value is List);
  }

  List<dynamic> _normalizeUsesField(dynamic value) {
    if (value is String) {
      return value.split(',').map((s) => s.trim()).toList();
    }
    return value ?? [];
  }
}
